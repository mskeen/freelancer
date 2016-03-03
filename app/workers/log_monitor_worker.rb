class LogMonitorWorker
  include Sidekiq::Worker

  IGNORE = [/.css$/, /.js$/, /.png$/, /.jpg$/, /.jpeg$/, /.gif$/, /.ico$/]
  DEFAULT_TAIL_LENGTH = 5 * 60 # 5 minutes

  def perform(log_monitor_id)
    @mon = LogMonitor[log_monitor_id]
    return if @mon.status != "pending"
    @ctr = 1
    @site = Site.where(token: @mon.site_id).first
    @mon.update(status: "processing")
    monitor_log_file(@site.access_log_cmd(@mon.log_type))
    puts "Done! #{@ctr} lines processed."
    @mon.update(status: "complete")
  end

  def monitor_log_file(cmd)
    IO.popen(cmd) do |io|
      io.each do |log_line|
        unless log_line.match(/internal dummy connection/)
          process_line(log_line)
        end
        return if job_done
      end
    end
  end

  def job_done
    @mon = LogMonitor[@mon.id]
    @mon.status == "cancelled" ||
      (@mon.log_type == "tail" &&
        ((Time.now.to_s(:db).to_datetime - @mon.created_at.to_datetime) * 24 * 60 * 60).to_i > DEFAULT_TAIL_LENGTH)
  end

  def process_line(log_line)
    if m = log_line.match(/^(?<ip>[\d\.]+) - - \[(?<time>[\s\S]+)\]/)
      ip = m['ip']
      tm = DateTime.strptime(m['time'], "%d/%b/%Y:%H:%M:%S %z")

      if log_line.match(/] "-" 408/)
        add_status_entry(ip, tm, "** Timed Out **")
      elsif m = log_line.match(/(?<method>GET|POST|HEAD|OPTIONS) (?<url>.+) HTTP\/\d\.\d" (?<status>\d+) (?<size>\d+) "(?<referrer>.*)" "(?<agent>.*)"/)
        keep = true
        f = m["url"].split('?')[0]
        IGNORE.each { |i| if f.match(i) then keep = false end }
        if keep
          add_entry(ip, tm, m['method'], m['url'], m['status'], m['size'], m['referrer'], m['agent'])
        end
      else
        puts "Mismatched entry: #{log_line}"
      end
      @ctr += 1
    else
      puts "Unprocessed line: #{log_line}"
    end
  end

  def add_status_entry(ip, tm, msg)
    add_entry(ip, tm, nil, nil, nil, nil, nil, nil, msg)
  end

  def add_entry(ip, tm, method, url, status, size, referrer, agent, msg = nil)
    log_ip = find_or_create_log_ip(ip, agent)
    log_ip.update(last_hit: tm.to_s(:db))
    entry = LogEntry.create(logged_at: tm.to_s(:db), method: method,
                            url: url, status: status, size: size,
                            referrer: referrer, status_msg: msg)
    log_ip.log_entries.add(entry)
  end

  def find_or_create_log_ip(ip, agent)
    log_ip = @mon.log_ips.find(ip: ip).first
    if !log_ip
      log_ip = LogIp.create(ip: ip, agent: agent)
      @mon.log_ips.add(log_ip)
    end
    @mon.incr :hits
    log_ip.incr :hits
    log_ip
  end

end
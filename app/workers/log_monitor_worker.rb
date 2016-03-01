class LogMonitorWorker
  include Sidekiq::Worker

  IGNORE = [/.css$/, /.js$/, /.png$/, /.jpg$/, /.jpeg$/, /.gif$/, /.ico$/]

  def perform(log_monitor_id)
    @ctr = 1
    @mon = LogMonitor[log_monitor_id]
    @site = Site.where(token: @mon.site_id).first
    monitor_log_file(@site.access_log_cmd)
    puts "Done! #{@ctr} lines processed."
    @mon.update status: LogMonitor.status(:complete)
  end

  def monitor_log_file(cmd)
    puts cmd
    IO.popen(cmd) do |io|
      io.each do |log_line|
        unless log_line.match(/internal dummy connection/)
          process_line(log_line)
          # exit if @done
          # break if @paused
        end
      end
    end
  end

  def process_line(log_line)
    if m = log_line.match(/^(?<ip>[\d\.]+) - - \[(?<time>[\s\S]+)\]/)
      ip = m['ip']
      tm = DateTime.strptime(m['time'], "%d/%b/%Y:%H:%M:%S %z")

      if log_line.match(/] "-" 408/)
        add_status_entry(ip, tm, "** Timed Out **")
      elsif m = log_line.match(/(?<method>GET|POST|HEAD) (?<url>.+) HTTP\/\d\.\d" (?<status>\d+) (?<size>\d+) "(?<referrer>.*)" "(?<agent>.*)"/)
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
    log_ip = find_or_create_log_ip(ip)
    log_ip.update(last_hit: tm)
    entry = LogEntry.create(logged_at: tm, status_msg: msg)
    log_ip.log_entries.add(entry)
  end

  def add_entry(ip, tm, method, url, status, size, referrer, agent)
    log_ip = find_or_create_log_ip(ip)
    log_ip.update(last_hit: tm, agent: agent, referrer: referrer)

    entry = LogEntry.create(logged_at: tm, method: method,
                            url: url, status: status, size: size,
                            referrer: referrer, agent: agent)
    log_ip.log_entries.add(entry)
  end

  def find_or_create_log_ip(ip)
    log_ip = @mon.log_ips.find(ip: ip).first
    if !log_ip
      log_ip = LogIp.create(ip: ip)
      @mon.log_ips.add(log_ip)
    end
    log_ip
  end
end
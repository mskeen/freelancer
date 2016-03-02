class LogMonitorWorker
  include Sidekiq::Worker

  IGNORE = [/.css$/, /.js$/, /.png$/, /.jpg$/, /.jpeg$/, /.gif$/, /.ico$/]
  DEFAULT_TAIL_LENGTH = 10 * 60 # 10 minutes

  def perform(log_monitor_id)
    @log_monitor_id = log_monitor_id
    @mon = LogMonitor[log_monitor_id]
    return if @mon.status != "pending"
    @ctr = 1
    @done = false
    @cancelled = false
    @site = Site.where(token: @mon.site_id).first
    @mon.update status: "processing"
    Thread.new { check_monitor_status }
    monitor_log_file(@site.access_log_cmd(@mon.log_type))
    puts "Done! #{@ctr} lines processed."
    if @cancelled
      @mon.update status: "cancelled"
    else
      @mon.update status: "complete"
    end
  end

  def monitor_log_file(cmd)
    puts cmd
    IO.popen(cmd) do |io|
      io.each do |log_line|
        unless log_line.match(/internal dummy connection/)
          process_line(log_line)
        end
        return if @done || @cancelled
      end
    end
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
    log_ip = find_or_create_log_ip(ip)
    log_ip.update(last_hit: tm.to_s(:db))
    entry = LogEntry.create(logged_at: tm, status_msg: msg)
    log_ip.log_entries.add(entry)
  end

  def add_entry(ip, tm, method, url, status, size, referrer, agent)
    log_ip = find_or_create_log_ip(ip)
    log_ip.update(last_hit: tm.to_s(:db), agent: agent, referrer: referrer)

    entry = LogEntry.create(logged_at: tm.to_s(:db), method: method,
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
    log_ip.incr :hits
    log_ip
  end

  def check_monitor_status
    loop do
      sleep(1)
      puts "Checking for cancelled status"
      @mon = LogMonitor[@log_monitor_id]
      if @mon.status == "cancelled"
        @cancelled = true
      end
      if @mon.log_type == "tail" &&
        ((Time.now.to_s(:db).to_datetime - mon.created_at.to_datetime) * 24 * 60 * 60).to_i > DEFAULT_TAIL_LENGTH
        @done = true
      end
      break if @done || @cancelled
    end
  end
end
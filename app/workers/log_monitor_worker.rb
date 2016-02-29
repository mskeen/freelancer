class LogMonitorWorker
  include Sidekiq::Worker

  IGNORE = [/.css$/, /.js$/, /.png$/, /.jpg$/, /.jpeg$/, /.gif$/, /.ico$/]

  def perform(log_monitor_id)
    @ctr = 1
    @mon = LogMonitor.find(log_monitor_id)
    monitor_log_file(@mon.site.access_log_cmd)
    puts "Done! #{@ctr} lines processed."
    @mon.status = LogMonitor.status(:complete)
    @mon.save
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
    m = log_line.match(/^(?<ip>[\d\.]+) - - \[(?<time>[\s\S]+)\]/)
    ip = m['ip']
    tm = DateTime.strptime(m['time'], "%d/%b/%Y:%H:%M:%S %z")

    if log_line.match(/] "-" 408/)
      add_status_entry(ip, tm, "** Timed Out **")
    elsif m = log_line.match(/(?<method>GET|POST|HEAD) (?<url>.+) HTTP\/\d\.\d" (?<status>\d+) (?<size>\d+) "(?<referrer>.+)" "(?<agent>.+)"/)
      keep = true
      f = m["url"].split('?')[0]
      IGNORE.each { |i| if f.match(i) then keep = false end }
      if keep
        add_entry(ip, tm, m['method'], m['url'], m['status'], m['size'], m['referrer'], m['agent'])
      end
    else
      puts "Mismatched entry: #{log_line}"
    end
  end

  def add_status_entry(ip, tm, msg)
    log_ip = @mon.log_ips.find_or_create_by(ip: ip)
    log_ip.last_hit = tm
    log_ip.save
    log_ip.log_entries.create(logged_at: tm, status_msg: msg)
  end

  def add_entry(ip, tm, method, url, status, size, referrer, agent)
    log_ip = @mon.log_ips.find_or_create_by(ip: ip)
    log_ip.last_hit = tm
    log_ip.agent = agent
    log_ip.referrer = referrer
    log_ip.save
    log_ip.log_entries.create(
      logged_at: tm, method: method, url: url, status: status, size: size,
      referrer: referrer, agent: agent
    )
  end
end
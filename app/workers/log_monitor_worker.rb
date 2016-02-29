class LogMonitorWorker
  include Sidekiq::Worker

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

  def process_line(line)
    @ctr += 1
  end
end
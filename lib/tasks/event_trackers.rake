namespace :trackers do

  desc 'Update the status of all running Event Trackers'
  task check: :environment do
    script_start = Time.zone.now
    EventTracker.active.running.due.each do |tracker|
      tracker.check(script_start)
    end
  end

end

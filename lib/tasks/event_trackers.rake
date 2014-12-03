namespace :data do

  desc 'Update the status of all running Event Trackers'
  task import: :environment do
    script_start = Time.zone.now
    EventTracker.active.running.each do |tracker|
      tracker.check(script_start)
    end
  end

end

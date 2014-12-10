# EventsTrackerStatusManager: define which types of status changes are
# allowed and execute appropriate communications when they occur.
class EventTrackerStatusManager
  def initialize(event_tracker)
    @event_tracker = event_tracker
  end

  def change_to_status(new_status)
    new_status == @event_tracker.status || distribute_status_message(new_status)
  end

  def distribute_status_message(new_status)
    method = calculate_method_name(new_status)
    if respond_to? method
      send(method)
      @event_tracker.status = new_status
      @event_tracker.save!
      return true
    end
    fail 'InvalidEventTrackerStatusChange'
  end

  def calculate_method_name(new_status)
    "#{@event_tracker.status.name}_to_#{new_status.name}"
  end

  def pending_to_ok
    @event_tracker.next_check_at = Time.zone.now
  end

  def ok_to_alert
    EventTrackerMailer.alert(@event_tracker).deliver
  end

  def alert_to_ok
    EventTrackerMailer.alert_cleared(@event_tracker).deliver
  end

  def paused_to_ok
  end

  alias_method :ok_to_paused, :paused_to_ok
  alias_method :alert_to_paused, :paused_to_ok
end

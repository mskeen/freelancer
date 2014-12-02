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
    return send(method) if respond_to? method
    fail 'InvalidEventTrackerStatusChange'
  end

  def calculate_method_name(new_status)
    "#{@event_tracker.status.name}_to_#{new_status.name}"
  end

  def pending_to_ok
    true
  end

  def ok_to_alert
    EventTrackerMailer.alert(@event_tracker).deliver
    true
  end

  def alert_to_ok
    EventTrackerMailer.alert_cleared(@event_tracker).deliver
    true
  end

  alias_method :paused_to_ok, :pending_to_ok
  alias_method :ok_to_paused, :pending_to_ok
  alias_method :alert_to_paused, :pending_to_ok
end

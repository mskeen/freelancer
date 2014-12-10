class EventTrackerMailer < ActionMailer::Base
  default from: AppConfig.support_email

  def alert(event_tracker)
    @event_tracker = event_tracker
    mail to: event_tracker.emails.join(","),
         subject: "Alert: #{@event_tracker.name}"
  end

  def alert_cleared(event_tracker)
    @event_tracker = event_tracker
    mail to: event_tracker.emails.join(","),
         subject: "Alert Cleared: #{@event_tracker.name}"
  end
end

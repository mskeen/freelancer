class EventTrackerPing < ActiveRecord::Base
  belongs_to :event_tracker

  default_scope { order(created_at: :desc) }
end

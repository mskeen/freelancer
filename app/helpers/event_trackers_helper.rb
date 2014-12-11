module EventTrackersHelper

  def tracker_class(event_tracker)
    'danger' if event_tracker.status == EventTracker.status(:alert)
  end

end

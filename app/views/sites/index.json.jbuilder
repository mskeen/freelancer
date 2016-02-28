json.array!(@event_trackers) do |event_tracker|
  json.extract! event_tracker, :id, :user_id, :organization_id, :name, :email, :notes, :interval_cd, :token, :sort_order, :is_paused, :is_deleted
  json.url event_tracker_url(event_tracker, format: :json)
end

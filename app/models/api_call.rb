class ApiCall < ActiveRecord::Base
  belongs_to :api_key

  def self.bump!(api_key)
    api_call = api_key.api_calls.where(
      starting_at: Time.zone.now.beginning_of_hour,
      ending_at: Time.zone.now.end_of_hour
      ).first_or_create
    api_call.increment!(:usage_count)
    api_call.usage_count
  end
end

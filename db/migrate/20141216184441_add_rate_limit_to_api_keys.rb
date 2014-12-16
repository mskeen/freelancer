class AddRateLimitToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :hourly_rate_limit, :integer, default: 1000
  end
end

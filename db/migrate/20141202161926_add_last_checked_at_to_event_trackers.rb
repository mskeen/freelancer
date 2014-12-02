class AddLastCheckedAtToEventTrackers < ActiveRecord::Migration
  def change
    add_column :event_trackers, :last_checked_at, :datetime
  end
end

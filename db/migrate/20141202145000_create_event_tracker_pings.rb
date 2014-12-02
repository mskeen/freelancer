class CreateEventTrackerPings < ActiveRecord::Migration
  def change
    create_table :event_tracker_pings do |t|
      t.references :event_tracker, index: true
      t.string :task_length
      t.string :comment

      t.timestamps
    end
  end
end

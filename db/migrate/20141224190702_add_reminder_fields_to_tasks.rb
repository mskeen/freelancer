class AddReminderFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :send_reminder, :boolean, default: false, null: false
    add_column :tasks, :reminder_lead_days, :integer, null: false, default: 1
    add_column :tasks, :reminder_sent_at, :datetime
  end
end

class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.references :log_ip, index: true, foreign_key: true
      t.datetime :logged_at
      t.string :method
      t.string :url
      t.string :status
      t.string :size
      t.string :referrer
      t.string :agent
      t.string :status_msg

      t.timestamps null: false
    end
  end
end

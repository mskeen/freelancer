class CreateEventTrackers < ActiveRecord::Migration
  def change
    create_table :event_trackers do |t|
      t.references :user, index: true, null: false
      t.references :organization, index: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :notes
      t.integer :interval_cd, null: false, default: 2
      t.string :token, null: false, limit: 16
      t.integer :sort_order, null: false, default: 0
      t.boolean :is_paused, null: false, default: false
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
  end
end

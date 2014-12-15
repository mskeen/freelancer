class CreateContacts < ActiveRecord::Migration
  def up
    create_table :contacts do |t|
      t.references :user, index: true
      t.integer :alertable_id
      t.string :alertable_type

      t.timestamps
    end
    remove_column :event_trackers, :email
  end

  def down
    drop_table :contacts
    add_column :event_trackers, :email, :string, null: false
  end
end

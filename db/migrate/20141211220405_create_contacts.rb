class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user, index: true, null: false
      t.references :organization, index: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :is_primary, null: false, default: false
      t.boolean :is_active, null: false, default: true
      t.boolean :is_paused, null: false, default: false
      t.timestamps
    end
  end
end

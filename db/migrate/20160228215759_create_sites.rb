class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.string :name
      t.string :url
      t.string :host
      t.string :log_location
      t.string :token
      t.integer :interval_cd
      t.integer :status_cd
      t.integer :ping_status_cd
      t.datetime :last_checked_at
      t.datetime :next_check_at
      t.boolean :is_deleted

      t.timestamps null: false
    end
    add_foreign_key :sites, :users
    add_foreign_key :sites, :organizations
  end
end

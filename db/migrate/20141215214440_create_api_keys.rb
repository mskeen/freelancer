class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :organization, index: true, null: false
      t.references :user, index: true, null: false
      t.string :token, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end

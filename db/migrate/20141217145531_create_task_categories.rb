class CreateTaskCategories < ActiveRecord::Migration
  def change
    create_table :task_categories do |t|
      t.references :user, index: true, null: false
      t.references :organization, index: true, null: false
      t.string :name, null: false
      t.boolean :is_shared, null: false, default: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end

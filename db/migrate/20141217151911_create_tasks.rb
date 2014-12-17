class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, null: false
      t.references :task_category, index: true, null: false
      t.string :title, null: false
      t.string :description, null: false, default: ''
      t.integer :weight, null: false, default: 1
      t.date :due_date
      t.integer :frequency_cd, null: false, default: Task.frequency(:none).id
      t.boolean :is_active, null: false, default: true
      t.integer :created_by_user_id, null: false
      t.datetime :completed_at
      t.integer :completed_by_user_id
      t.timestamps
    end
  end
end

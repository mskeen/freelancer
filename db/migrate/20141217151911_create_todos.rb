class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.references :user, index: true, null: false
      t.references :todo_category, index: true, null: false
      t.string :title, null: false
      t.string :description, null: false, default: ''
      t.integer :weight, null: false, default: 1
      t.date :due_date
      t.integer :frequency_cd, null: false, default: Todo.frequency(:none).id
      t.integer :created_by_user_id, null: false
      t.datetime :completed_at
      t.integer :completed_by_user_id
      t.timestamps
    end
  end
end

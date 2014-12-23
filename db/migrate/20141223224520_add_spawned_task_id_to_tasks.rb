class AddSpawnedTaskIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :spawned_task_id, :integer
  end
end

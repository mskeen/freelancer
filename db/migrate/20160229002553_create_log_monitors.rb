class CreateLogMonitors < ActiveRecord::Migration
  def change
    create_table :log_monitors do |t|
      t.references :user, index: true, foreign_key: true
      t.references :site, index: true, foreign_key: true
      t.integer :status_cd

      t.timestamps null: false
    end
  end
end

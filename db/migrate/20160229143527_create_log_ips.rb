class CreateLogIps < ActiveRecord::Migration
  def change
    create_table :log_ips do |t|
      t.references :log_monitor, index: true, foreign_key: true
      t.datetime :last_hit
      t.string :agent
      t.string :referrer

      t.timestamps null: false
    end
  end
end

class CreateApiCalls < ActiveRecord::Migration
  def change
    create_table :api_calls do |t|
      t.references :api_key, index: true
      t.datetime :starting_at
      t.datetime :ending_at
      t.integer :usage_count, default: 0
      t.timestamps
    end
  end
end

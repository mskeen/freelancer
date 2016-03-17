class AddLogFilterToSites < ActiveRecord::Migration
  def change
    add_column :sites, :log_filter, :string
  end
end

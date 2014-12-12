class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_cd, :integer, default: User.role(:root).id
  end
end

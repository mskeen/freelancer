class AddIsInvitedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_invited, :boolean, default: true
    add_column :users, :created_by_user_id, :integer
  end
end

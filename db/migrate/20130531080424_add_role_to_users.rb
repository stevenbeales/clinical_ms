class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_role_id, :integer
  end
end

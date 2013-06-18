class AddUsersToPos < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :created_by, :integer
    add_column :purchase_orders, :modified_by, :integer
  end
end

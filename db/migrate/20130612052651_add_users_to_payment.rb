class AddUsersToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :created_by, :integer
    add_column :payments, :modified_by, :integer
  end
end

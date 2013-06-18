class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :quantity
      t.float :amount

      t.timestamps
    end
  end
end

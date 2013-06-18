class CreatePurchaseOrderItems < ActiveRecord::Migration
  def change
    create_table :purchase_order_items do |t|
      t.integer :purchase_order_id
      t.integer :quantity
      t.float :cost
      t.integer :purchase_inventories_supplier_id

      t.timestamps
    end
  end
end

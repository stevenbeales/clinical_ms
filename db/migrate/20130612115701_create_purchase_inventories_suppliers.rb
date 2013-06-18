class CreatePurchaseInventoriesSuppliers < ActiveRecord::Migration
  def change
    create_table :purchase_inventories_suppliers do |t|
      t.integer :purchase_inventory_id
      t.integer :supplier_id
      t.float :unit_price

      t.timestamps
    end
  end
end

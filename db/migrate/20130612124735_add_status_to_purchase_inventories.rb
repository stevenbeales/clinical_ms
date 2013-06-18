class AddStatusToPurchaseInventories < ActiveRecord::Migration
  def change
    add_column :purchase_inventories_suppliers, :status, :string
  end
end

class CreatePurchaseInventories < ActiveRecord::Migration
  def change
    create_table :purchase_inventories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end

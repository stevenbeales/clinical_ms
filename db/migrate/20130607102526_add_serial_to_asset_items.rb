class AddSerialToAssetItems < ActiveRecord::Migration
  def change
    add_column :asset_items, :serial_number, :string
  end
end

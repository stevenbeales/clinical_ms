class CreateAssetItems < ActiveRecord::Migration
  def change
    create_table :asset_items do |t|
      t.integer :asset_id

      t.timestamps
    end
  end
end

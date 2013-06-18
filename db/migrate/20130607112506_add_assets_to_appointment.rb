class AddAssetsToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :asset_item_id, :integer
    add_column :appointments, :asset_hour_unit, :float
    add_column :appointments, :amount, :float
  end
end

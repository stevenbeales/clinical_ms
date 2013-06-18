class AddAddressToClinic < ActiveRecord::Migration
  def change
    add_column :clinics, :address, :string
  end
end

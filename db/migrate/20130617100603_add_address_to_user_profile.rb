class AddAddressToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :address, :string
  end
end

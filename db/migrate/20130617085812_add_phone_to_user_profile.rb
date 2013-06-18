class AddPhoneToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :phone, :integer
  end
end

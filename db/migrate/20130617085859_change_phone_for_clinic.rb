class ChangePhoneForClinic < ActiveRecord::Migration
  def up
  	change_column :clinics, :phone, :integer
  end

  def down
  	change_column :clinics, :phone, :string
  end
end

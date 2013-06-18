class CreatePatientProfiles < ActiveRecord::Migration
  def change
    create_table :patient_profiles do |t|
      t.integer :patient_id
      t.string :uid

      t.timestamps
    end
  end
end

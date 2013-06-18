class AddEmergencyInfoToPatientProfile < ActiveRecord::Migration
  def change
    add_column :patient_profiles, :emergency_contact_names, :string
    add_column :patient_profiles, :emergency_contact_nos, :string
  end
end

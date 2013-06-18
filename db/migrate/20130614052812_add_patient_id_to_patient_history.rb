class AddPatientIdToPatientHistory < ActiveRecord::Migration
  def change
    add_column :patient_histories, :patient_id, :integer
  end
end

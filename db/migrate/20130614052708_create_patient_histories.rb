class CreatePatientHistories < ActiveRecord::Migration
  def change
    create_table :patient_histories do |t|
      t.string :consultant_name
      t.string :consultant_clinic_name
      t.integer :consultant_phone_no
      t.string :symptoms
      t.string :medication
      t.date :from_date
      t.date :to_date
      t.string :follow_up

      t.timestamps
    end
  end
end

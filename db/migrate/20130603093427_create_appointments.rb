class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :patient_id
      t.integer :department_id
      t.integer :practitioner_id
      t.date :appointment_date
      t.string :from_time
      t.string :to_time

      t.timestamps
    end
  end
end

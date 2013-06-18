class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :phone
      t.string :work_from_time
      t.string :work_to_time

      t.timestamps
    end
  end
end

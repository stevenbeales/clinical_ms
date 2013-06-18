class CreateVitals < ActiveRecord::Migration
  def change
    create_table :vitals do |t|
      t.integer :appointment_id
      t.string :height
      t.string :weight
      t.string :blood_pressure
      t.string :sugar_level
      t.string :temperature

      t.timestamps
    end
  end
end

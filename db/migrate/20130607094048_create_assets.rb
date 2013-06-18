class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.integer :clinic_id
      t.integer :hour_unit
      t.float :cost

      t.timestamps
    end
  end
end

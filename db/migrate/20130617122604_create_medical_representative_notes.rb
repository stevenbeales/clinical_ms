class CreateMedicalRepresentativeNotes < ActiveRecord::Migration
  def change
    create_table :medical_representative_notes do |t|
      t.integer :practitioner_id
      t.string :rep_name
      t.string :rep_company
      t.integer :rep_phone
      t.string :notes

      t.timestamps
    end
  end
end

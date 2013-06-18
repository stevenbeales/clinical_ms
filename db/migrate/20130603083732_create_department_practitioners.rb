class CreateDepartmentPractitioners < ActiveRecord::Migration
  def change
    create_table :department_practitioners do |t|
      t.integer :department_id
      t.integer :practitioner

      t.timestamps
    end
  end
end

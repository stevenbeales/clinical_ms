class RenamePractitionerForDepartmentPractitioner < ActiveRecord::Migration
  def up
  	rename_column :department_practitioners, :practitioner, :practitioner_id
  end

  def down
  	# not reversible
  end
end

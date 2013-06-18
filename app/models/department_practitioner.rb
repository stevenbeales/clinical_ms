class DepartmentPractitioner < ActiveRecord::Base
  attr_accessible :department_id, :practitioner_id

  belongs_to :department
  belongs_to :practitioner
end

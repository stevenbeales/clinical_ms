class Department < ActiveRecord::Base
  attr_accessible :clinic_id, :name

  belongs_to :clinic
  has_many :department_practitioners
  has_many :practitioners, :through => :department_practitioners
  has_many :appointments

  validates :clinic_id, :presence => true, :numericality => true
  validates :name, :presence => true
end

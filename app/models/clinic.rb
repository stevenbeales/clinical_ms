class Clinic < ActiveRecord::Base
  attr_accessible :name, :phone, :work_from_time, :work_to_time, :address

  has_many :departments
  
  validates :name, :presence => true
  validates :phone, :presence => true, :numericality => true, :length => { :in => 8..10 }
  validates :work_from_time, :presence => true
  validates :work_to_time, :presence => true
  validates :address, :presence => true
end

class PatientHistory < ActiveRecord::Base
  attr_accessible :consultant_clinic_name, :consultant_name, :consultant_phone_no, 
  	:follow_up, :from_date, :medication, :symptoms, :to_date

  belongs_to :patient
  
	validates :consultant_name, :presence => true
  validates :consultant_clinic_name, :presence => true
  validates :consultant_phone_no, :presence => true, :numericality => true, :length => { :in => 8..10 }
  validates :symptoms, :presence => true
  validates :medication, :presence => true
  validates :from_date, :presence => true
  validates :to_date, :presence => true
  validates :follow_up, :presence => true
end

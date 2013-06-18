class PatientProfile < ActiveRecord::Base
  attr_accessible :patient_id, :uid, :emergency_contact_names, :emergency_contact_nos
	
	belongs_to :patient
  
	validates :uid, :presence => true
	validates :emergency_contact_names, :presence => true
	validates :emergency_contact_nos, :presence => true
	validates_uniqueness_of :uid, :scope => :patient_id, :on => :create
end

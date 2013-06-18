class Vital < ActiveRecord::Base
  attr_accessible :blood_pressure, :height, :sugar_level, :temperature, :weight

  belongs_to :appointment
  has_one :patient, :through => :appointment

  validates :height, :presence => true
  validates :weight, :presence => true
  validates :blood_pressure, :presence => true
  validates :sugar_level, :presence => true
  validates :temperature, :presence => true
  validates_uniqueness_of :id, :scope => :appointment_id, :on => :create
end

class Asset < ActiveRecord::Base
  attr_accessible :clinic_id, :cost, :hour_unit, :name

  belongs_to :clinic
  has_many :asset_items
  
  validates :clinic_id, :presence => true, :numericality => true
  validates :cost, :presence => true, :numericality => true
  validates :hour_unit, :presence => true, :numericality => true
  validates :name, :presence => true
end

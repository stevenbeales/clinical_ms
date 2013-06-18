class CancellationReason < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :numericality => true
end

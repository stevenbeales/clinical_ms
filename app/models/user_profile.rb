class UserProfile < ActiveRecord::Base
  attr_accessible :date_of_birth, :gender, :name, :phone, :address

  belongs_to :user

  validates :name, :presence => true
  validates :gender, :presence => true, :inclusion => { :in => ["Male", "Female"] }
  validates :date_of_birth, :presence => true
  validates_uniqueness_of :user_id, :scope => :id, :on => :create
  validates :phone, :presence => true, :numericality => true, :length => { :in => 8..10 }
  validates :address, :presence => true
  validate :should_be_back_dated_dob

  def should_be_back_dated_dob
  	if self.date_of_birth > Date.today
  		errors.add(:date_of_birth, "Cannot be in future")
  		false
  	end
  end

  def age
  	(Date.today - date_of_birth).to_i / 365 # years
  end
end

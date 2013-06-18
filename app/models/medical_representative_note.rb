class MedicalRepresentativeNote < ActiveRecord::Base
  attr_accessible :notes, :rep_company, :rep_name, :rep_phone

  belongs_to :practitioner

  validates :notes, :presence => true
  validates :rep_name, :presence => true
  validates :rep_company, :presence => true
  validates :rep_phone, :presence => true, :numericality => true, :length => { :in => 8..10 }

  searchable do
  	text :rep_name, :rep_company, :notes
  	integer :practitioner_id
  end
end

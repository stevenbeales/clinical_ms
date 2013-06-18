class Payment < ActiveRecord::Base
  attr_accessible :paid_amount, :payment_items_attributes

  has_many :payment_items
  belongs_to :creator, :class_name => "User", :foreign_key => :created_by
  belongs_to :modifier, :class_name => "User", :foreign_key => :modified_by
  
  accepts_nested_attributes_for :payment_items

  validates :amount, :presence => true, :numericality => { :greater_than => 0.0 }
  validates :discount, :presence => true, :numericality => true
  validates :paid_amount, :presence => true, :numericality => true
  validate :amount_should_be_equal_to_paid_and_discount

  before_validation :set_amount_and_discount

  searchable do
    text :creator do
      creator.name
    end
    time :created_at
  end

  def set_amount_and_discount
  	self.amount = payment_items.inject(0.0) { |sum, item| sum += item.amount }
  	self.discount = payment_items.inject(0.0) { |sum, item| sum += item.discount }
  end

  def amount_should_be_equal_to_paid_and_discount
  	errors.add(:amount, "should be equal to paid amount and discount") unless amount == (paid_amount.to_f + discount)
  end

  def build_appointment_payment_items(patient_id, discount)
  	appointments = Appointment.find(:all, 
  		:conditions => ["patient_id = ?", patient_id]).
  			map { |appointment| appointment if !appointment.paid? }.compact
  	unless appointments.empty?
	  	appointments.each do |appointment|
	  		payment_item = payment_items.build(:discount => discount.to_f)

	  		# protected attributes
	  		payment_item.transaction_type = appointment.class.name
	  		payment_item.transaction_id = appointment.id
	  		payment_item.amount = appointment.amount
	  	end  	
	  end
  end

  def build_purchase_payment_items(supplier_id, discount)
    pos = Supplier.find(supplier_id).purchase_orders.
        map { |po| po if !po.paid? }.compact.uniq
    unless pos.empty?
      pos.each do |po|
        payment_item = payment_items.build(:discount => discount.to_f)

        # protected attributes
        payment_item.transaction_type = po.class.name
        payment_item.transaction_id = po.id
        payment_item.amount = po.amount
      end   
    end
  end
end

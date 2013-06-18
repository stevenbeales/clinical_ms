class PurchaseOrder < ActiveRecord::Base
  attr_accessible :amount, :quantity, :purchase_order_items_attributes

  has_many :purchase_order_items
  has_one :payment_item, :as => :transaction
  belongs_to :creator, :class_name => "User", :foreign_key => :created_by
  belongs_to :modifier, :class_name => "User", :foreign_key => :modified_by

  accepts_nested_attributes_for :purchase_order_items, :allow_destroy => true

  validates :amount, :presence => true, :numericality => { :greater_than => 0 }
  validates :quantity, :presence => true, :numericality => { :greater_than => 0 }
  validate :amount_must_be_tamper_proof
  before_validation :set_amount_and_quantity

  searchable do
    text :purchase_order_items do
      purchase_order_items.map { |item| item.purchase_inventory.name }
    end
    text :purchase_order_items do
      purchase_order_items.map { |item| item.supplier.name }
    end
    time :created_at
  end

  def amount_must_be_tamper_proof
    unless purchase_order_items.empty?
      amount_by_calculation = purchase_order_items.inject(0.0) { |sum, item| sum += item.cost } rescue 0.0
      errors.add(:amount, "is invalid, User action will be reported") if amount != amount_by_calculation
    end
  end

  def set_amount_and_quantity
    self.amount = purchase_order_items.inject(0.0) { |sum, item| sum += item.cost } rescue 0.0
    self.quantity = purchase_order_items.inject(0.0) { |sum, item| sum += item.quantity } rescue 0
  end
  
  def paid?
    !payment_item.nil?
  end

  def date
    created_at
  end
end

class PurchaseOrderItem < ActiveRecord::Base
  attr_accessible :cost, :purchase_inventories_supplier_id, :purchase_order_id, 
  	:quantity

  belongs_to :purchase_order
  belongs_to :purchase_inventories_supplier
  has_one :purchase_inventory, :through => :purchase_inventories_supplier
  has_one :supplier, :through => :purchase_inventories_supplier

  validates :purchase_inventories_supplier_id, :presence => true, :numericality => true
  validates :cost, :presence => true, :numericality => { :greater_than => 0 }
  validates :quantity, :presence => true, :numericality => { :greater_than => 0 }
  validate :cost_must_be_tamper_proof

  def cost_must_be_tamper_proof
  	if purchase_inventories_supplier and quantity
    	errors.add(:cost, 
    		"is invalid, User action will be reported") if cost != 
    			(purchase_inventories_supplier.unit_price * quantity)
    end
  end
end

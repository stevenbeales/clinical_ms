class PurchaseInventoriesSupplier < ActiveRecord::Base
  attr_accessible :purchase_inventory_id, :supplier_id, :unit_price, :status

  belongs_to :purchase_inventory
  belongs_to :supplier
  has_many :purchase_order_items

	delegate :name, :description, :to => :purchase_inventory

  validates :purchase_inventory_id, :presence => true, :numericality => true
  validates :supplier_id, :presence => true, :numericality => true
  validates :unit_price, :presence => true, :numericality => { :greater_than => 0.0 }
  validates :status, :presence => true, :inclusion => { :in => ["In Stock", "Out of Stock"] }
end

class PurchaseInventory < ActiveRecord::Base
  attr_accessible :description, :name

	has_many :purchase_inventories_suppliers
  has_many :suppliers, :through => :purchase_inventories_suppliers

  validates :name, :presence => true
  validates :description, :presence => true

  searchable do
    text :name, :description
    text :suppliers do
      suppliers.map { |supplier| supplier.name }
    end
	end
end

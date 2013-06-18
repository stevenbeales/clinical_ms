class Supplier < User
	attr_accessible :purchase_inventories_suppliers_attributes

	before_validation :set_user_role, :set_default_password, :on => :create

	default_scope where("user_role_id = ?", UserRole.find_by_name("supplier").id)

	has_many :purchase_inventories_suppliers
	has_many :purchase_inventories, :through => :purchase_inventories_suppliers
	has_many :purchase_order_items, :through => :purchase_inventories_suppliers
	has_many :purchase_orders, :through => :purchase_order_items
	has_many :payment_items, :through => :purchase_orders
	has_many :payments, :through => :payment_items

	validate :must_have_user_profile

	accepts_nested_attributes_for :purchase_inventories_suppliers, :allow_destroy => true

	searchable do
    text :name, :email
    text :purchase_inventories do
      purchase_inventories.map { |inventory| inventory.name }
    end
	end

  def must_have_user_profile
    if user_profile.nil? or user_profile.marked_for_destruction?
      errors.add(:base, 'Invalid user profile, please try again')
    end
  end

  private
	def set_default_password
		default_password = Settings.default_password
		self.password = default_password
		self.password_confirmation = default_password
	end

	def set_user_role
		self.user_role_id = UserRole.user_role_id(self)
	end
end

class Admin < User
	before_validation :set_user_role, :on => :create
	default_scope where("user_role_id = ?", UserRole.find_by_name("admin").id)

	private
	def set_user_role
		self.user_role_id = UserRole.user_role_id(self)
	end
end

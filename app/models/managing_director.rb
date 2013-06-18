class ManagingDirector < User
	before_validation :set_user_role, :set_default_password, :on => :create

	default_scope where("user_role_id = ?", UserRole.find_by_name("managing_director").id)

	validate :must_have_user_profile

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

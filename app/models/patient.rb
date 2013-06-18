class Patient < User
	before_validation :set_user_role, :set_default_password, :on => :create

	default_scope where("user_role_id = ?", UserRole.find_by_name("patient").id)

	delegate :uid, :emergency_contact_names, :emergency_contact_nos, :to => :patient_profile
	
	attr_accessible :patient_profile_attributes

	has_many :appointments
	has_many :payment_items, :through => :appointments
	has_many :payments, :through => :payment_items
	has_many :patient_histories
	has_one :patient_profile

	accepts_nested_attributes_for :patient_profile, :allow_destroy => true

	validate :must_have_user_profile

  def must_have_user_profile
    if user_profile.nil? or user_profile.marked_for_destruction?
      errors.add(:base, 'Invalid user profile, please try again')
    end
  end

	searchable do
    text :name, :email
    text :appointments do
      appointments.map { |appointment| appointment.practitioner.name }
    end
	end

	def dues
		dues = appointments.where("status <> ?", "Cancelled").
			inject(0.0) { |dues, appointment| dues += appointment.amount unless appointment.paid? }
		dues.nil? ? 0.0 : dues
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

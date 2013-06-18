class Practitioner < User
	before_validation :set_user_role, :set_default_password, :on => :create
	
	default_scope where("user_role_id = ?", UserRole.find_by_name("practitioner").id)

	attr_accessible :department_practitioner_attributes

	has_one :department_practitioner, :dependent => :destroy
	has_one :department, :through => :department_practitioner
	has_many :appointments
	has_many :medical_representative_notes
	
	validate :must_have_department
	validate :must_have_user_profile

  accepts_nested_attributes_for :department_practitioner, :allow_destroy => true

  def must_have_department
  	if department_practitioner.department.nil? or department_practitioner.department.marked_for_destruction?
      errors.add(:base, 'Invalid department, please try again')
    end
  end

  def must_have_user_profile
    if user_profile.nil? or user_profile.marked_for_destruction?
      errors.add(:base, 'Invalid user profile, please try again')
    end
  end

  searchable do
    text :name, :email
    text :appointments do
      appointments.map { |appointment| appointment.patient.name }
    end
	end

	def self.slot_taken?(practitioner, slot_time)
		slot_time_string = slot_time.strftime("%H:%M %p")
		return true if slot_time_string < (Time.parse practitioner.department.clinic.work_from_time).
			strftime("%H:%M %p")
		return true if slot_time_string > ((Time.parse practitioner.department.clinic.work_to_time) - 
      Settings.minimum_appointment_time.minutes).strftime("%H:%M %p")
		appointments = practitioner.appointments.where("appointment_date = ?", Date.parse(slot_time.to_s))
		appointments.each do |appointment|
			return true if appointment.status == "Pending" and 
        (Time.parse slot_time_string).strftime("%H:%M %p") >= (Time.parse appointment.from_time).strftime("%H:%M %p") and 
          (Time.parse slot_time_string).strftime("%H:%M %p") <= (Time.parse appointment.to_time).strftime("%H:%M %p")
		end
		false
	end

	def build_appointment_slots(from_date, to_date)
		slots = []
		Range.new(from_date.to_i, 
			to_date.to_i).step(Settings.minimum_appointment_time.minutes) do |seconds_since_epoch|
			  slots << Time.at(seconds_since_epoch) unless self.class.slot_taken?(self, Time.at(seconds_since_epoch))
		end
		slots
	end

	def available?(appointment_id, date, from_time, to_time)
		appointments = appointments.where(:appointment_date => date) rescue []
    appointments.each do |appointment|
      next if appointment_id and appointment.id == appointment_id
      return false if (Time.parse from_time).strftime("%H:%M %p") >= (Time.parse appointment.from_time).strftime("%H:%M %p") and 
        (Time.parse from_time).strftime("%H:%M %p") <= (Time.parse appointment.to_time).strftime("%H:%M %p")
      return false if (Time.parse to_time).strftime("%H:%M %p") >= (Time.parse appointment.from_time).strftime("%H:%M %p") and 
        (Time.parse to_time).strftime("%H:%M %p") <= (Time.parse appointment.to_time).strftime("%H:%M %p")
    end
    true
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

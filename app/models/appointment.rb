class Appointment < ActiveRecord::Base
  attr_accessible :appointment_date, :department_id, :from_time, :patient_id, 
  	:practitioner_id, :to_time, :status, :cancellation_reason_id, 
    :asset_item_id, :asset_hour_unit

  belongs_to :department
  belongs_to :patient
  belongs_to :practitioner
  belongs_to :cancellation_reason
  belongs_to :creator, :class_name => "User", :foreign_key => :created_by
  belongs_to :modifier, :class_name => "User", :foreign_key => :modified_by
  belongs_to :asset_item
  has_one :asset, :through => :asset_item
  has_one :payment_item, :as => :transaction
  has_one :vital, :dependent => :destroy

  validates :department_id, :presence => true, :numericality => true
  validates :patient_id, :presence => true, :numericality => true
  validates :practitioner_id, :presence => true, :numericality => true
  validates :appointment_date, :presence => true
  validates :from_time, :presence => true
  validates :to_time, :presence => true
  validates :status, :presence => true, :inclusion => 
    { :in => ["Pending", "Cancelled", "Completed"] }
  validates :asset_item_id, :presence => true, :numericality => true
  validates :asset_hour_unit, :presence => true, :numericality => true
  validates :amount, :presence => true, :numericality => true
  validate :should_not_be_back_dated_appointment
  validate :should_be_schedulable_appointment_time
  validate :must_have_practitioner_available
  validate :should_be_within_clinic_timings
  validate :must_have_pending_status_on_create, :on => :create
  validate :cannot_allow_completed_to_update, :on => :update
  validate :cannot_allow_cancelled_to_update, :on => :update
  validate :must_have_reason_on_cancellation
  validate :must_have_asset_available

  before_validation :set_default_appointment_date, :set_amount

  searchable do
    text :status
    text :patient do
      patient.name
    end
    text :practitioner do
      practitioner.name
    end
    text :department do
      department.name
    end
    text :asset_item do
      asset_item.serial_number
    end
    text :asset do
      asset.name
    end
    time :appointment_date
  end

  def should_not_be_back_dated_appointment
    errors.add(:appointment_date, "should not be back dated") if appointment_date.past? and status == "Pending"
  end

  def should_be_schedulable_appointment_time
    if status == "Pending"
      if appointment_date.today?
        errors.add(:from_time, "should not be in the past") if (Time.parse from_time).past?
        errors.add(:to_time, "should not be in the past") if (Time.parse to_time).past?
      end

      errors.add(:base, "Appointment time is too short") if ((Time.parse to_time) - 
        (Time.parse from_time)) / 60 < Settings.minimum_appointment_time
    end
  end  

  def must_have_practitioner_available
    if practitioner
      errors.add(:practitioner, 
        "is already scheduled for an appointment for that time duration") if status == "Pending" and
          !practitioner.available?(id, appointment_date, from_time, to_time)
    end
  end

  def should_be_within_clinic_timings
    if status == "Pending" and department
      errors.add(:from_time, "is beyond clinic work hours") if (Time.parse from_time).strftime("%H:%M %p") < (Time.parse department.clinic.work_from_time).strftime("%H:%M %p") or 
        (Time.parse from_time).strftime("%H:%M %p") >= (Time.parse department.clinic.work_to_time).strftime("%H:%M %p")
      errors.add(:to_time, "is beyond clinic work hours") if (Time.parse to_time).strftime("%H:%M %p") < (Time.parse department.clinic.work_from_time).strftime("%H:%M %p") or 
        (Time.parse to_time).strftime("%H:%M %p") >= (Time.parse department.clinic.work_to_time).strftime("%H:%M %p")
    end
  end

  def must_have_pending_status_on_create
    errors.add(:status, "must be Pending with a new Appointment") unless status == "Pending"
  end

  def cannot_allow_completed_to_update
    if status_was == "Completed"
      errors.add(:status, "cannot be updated from Completed")
    end
  end

  def cannot_allow_cancelled_to_update
    if status_was == "Cancelled"
      errors.add(:status, "cannot be updated from Cancelled")
    end
  end

  def must_have_reason_on_cancellation
    if status == "Cancelled"
      errors.add(:cancellation_reason_id, "cannot be blank") unless cancellation_reason_id.present?
    end
  end

  def must_have_asset_available
    if asset_item
      errors.add(:asset_item_id, "is already taken for that time duration") if status == "Pending" and 
        !asset_item.available?(id, appointment_date, from_time, to_time)
    end
  end

  def active?
    return false unless status == "Pending"
    return false if appointment_date.past?
    if appointment_date.today?
      return false if (Time.parse to_time).past?
    end
    true
  end

  def date
    appointment_date
  end

  def self.practitioners_by_options(options)
    practitioners = Department.find(options[:department_id]).practitioners
    reference_date = Time.now
    from_date = reference_date.beginning_of_hour + 1.hour
    to_date = reference_date.end_of_day.advance(:days => Settings.appointment_slot_duration)
    stuff = []
    practitioners.each do |practitioner|
      stuff << { :practitioner => practitioner.name, 
        :department => practitioner.department.name,
        :slot_times => practitioner.build_appointment_slots(from_date, to_date) }
    end
    stuff
  end

  def self.asset_items_by_options(options)
    asset_items = AssetItem.find(options[:asset_item_id]).asset.asset_items
    reference_date = Time.now
    from_date = reference_date.beginning_of_hour + 1.hour
    to_date = reference_date.end_of_day.advance(:days => Settings.appointment_slot_duration)
    stuff = []
    asset_items.each do |asset_item|
      stuff << { :asset => asset_item.decorated_name,
        :slot_times => asset_item.build_appointment_slots(from_date, to_date) }
    end
    stuff
  end

  def paid?
    !payment_item.nil?
  end

  private
  def set_default_appointment_date
    self.appointment_date = Date.today if self.appointment_date.nil?
  end

  def set_amount
    self.amount = asset_item.amount(asset_hour_unit) rescue nil
  end
end

class AssetItem < ActiveRecord::Base
  attr_accessible :asset_id, :serial_number
  
  belongs_to :asset
  has_many :appointments
  delegate :name, :cost, :hour_unit, :to => :asset
  
  validates :asset_id, :presence => true, :numericality => true
  validates :serial_number, :presence => true, :uniqueness => true

  searchable do
    text :serial_number
    text :asset do
      asset.name
    end
    text :appointments do
      appointments.map { |appointment| appointment.status }
    end
  end

  def decorated_name
  	name + " " + serial_number
  end

  def amount(for_no_of_hours)
  	return nil unless for_no_of_hours.is_a? Numeric
  	((for_no_of_hours.to_f / hour_unit.to_f) * cost).round(2)
  end

  def self.slot_taken?(asset_item, slot_time)
    slot_time_string = slot_time.strftime("%H:%M %p")
    return true if slot_time_string < (Time.parse asset_item.asset.clinic.work_from_time).
      strftime("%H:%M %p")
    return true if slot_time_string >= ((Time.parse asset_item.asset.clinic.work_to_time) - 
      Settings.minimum_appointment_time.minutes).strftime("%H:%M %p")
    appointments = asset_item.appointments.where("appointment_date = ?", Date.parse(slot_time.to_s))
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
    a_s = appointments.where(:appointment_date => date) rescue []
    a_s.each do |appointment|
      next if appointment_id and appointment.id == appointment_id
  		return false if (Time.parse from_time).strftime("%H:%M %p") >= (Time.parse appointment.from_time).strftime("%H:%M %p") and 
        (Time.parse from_time).strftime("%H:%M %p") <= (Time.parse appointment.to_time).strftime("%H:%M %p")
      return false if (Time.parse to_time).strftime("%H:%M %p") >= (Time.parse appointment.from_time).strftime("%H:%M %p") and 
        (Time.parse to_time).strftime("%H:%M %p") <= (Time.parse appointment.to_time).strftime("%H:%M %p")
  	end
  	true
  end
end

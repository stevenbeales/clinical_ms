class Ability
  include CanCan::Ability

  def initialize(user)
		# Define abilities for the passed in user here. For example:
		if user.admin?
			can :manage, :all
			cannot :read, PatientHistory
			cannot :read, Vital
			cannot :read, MedicalRepresentativeNote
		end 

		if user.patient?
			can :read, Patient, :id => user.id
			can :read, PatientHistory
			can :read, Payment
			can :read, Appointment, :patient_id => user.id
			can :read, Vital
			can :manage, UserProfile, :user_id => user.id
		end

		if user.practitioner?
			can :read, Practitioner, :id => user.id
			can :read, Appointment, :practitioner_id => user.id
			can :manage, Vital
			can :read, Patient
			can :read, PatientHistory
			can :manage, MedicalRepresentativeNote, :practitioner_id => user.id
			can :manage, UserProfile, :user_id => user.id
		end

		if user.staff?
			can :read, PurchaseOrder
			can :read, PurchaseInventory
			can :read, Supplier
			can :read, AssetItem

			can :manage, Patient
			cannot :destroy, Patient

			can :manage, PatientHistory
			cannot :destroy, PatientHistory

			can :manage, Appointment
			cannot :destroy, Appointment

			can :manage, Vital

			can :manage, Payment
			cannot :destroy, Payment
			
			can :manage, UserProfile, :user_id => user.id
		end

		if user.managing_director?
			can :manage, UserProfile, :user_id => user.id
		end
  end
end

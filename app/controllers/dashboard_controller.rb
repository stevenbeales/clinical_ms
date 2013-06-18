class DashboardController < ApplicationController
  def index
  	if current_user.patient?
  		@patient = Patient.find(current_user.id)

	  	@appointments = Appointment.where(:patient_id => @patient.id, :status => "Pending")
	  	@date = params[:month] ? Date.parse(params[:month]) : Date.today

	    @histories = @patient.patient_histories.order("created_at desc").last(5)

 	    @payments = @patient.payments.order("created_at desc").uniq.last(5)
	  end
	  if current_user.practitioner?
	  	@appointments = Appointment.where(:practitioner_id => current_user.id, :status => "Pending")
	  	@date = params[:month] ? Date.parse(params[:month]) : Date.today
	  end
	  if current_user.staff?
	  	@appointments = Appointment.where(:status => "Pending")
	  end
  end
end

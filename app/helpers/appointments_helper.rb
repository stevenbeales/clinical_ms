module AppointmentsHelper
	def decorated_status(appointment)
		status = ""
		if appointment.active? 
			status = '<span class="label label-success">Active</span>'
		else
			if appointment.status == "Completed" 
				status = '<span class="label label-info">Completed</span>'
			elsif appointment.status == "Cancelled" 
				status = '<span class="label">Cancelled</span>'
			else
				status = '<span class="label label-important">Inactive</span>'
			end 
		end
		status.html_safe
	end
end

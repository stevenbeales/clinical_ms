class UserStepsController < ApplicationController
	include Wicked::Wizard
  steps :clinic_setup

  def show
  	@user = current_user
  	case step
  	when :clinic_setup
    	@clinic = Clinic.new
    end
  	render_wizard
  end

  def update
	  case step
  	when :clinic_setup
	  	@clinic = Clinic.new
		  @clinic.attributes = params[:clinic]
		  render_wizard @clinic
		end
	end

  private
	def finish_wizard_path
		flash[:notice] = "Thanks for Signing up with ClinicalMS."
	  dashboard_url
	end
end

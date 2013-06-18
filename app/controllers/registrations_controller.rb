class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
 		@user = Admin.new(params[:user])
		if @user.save
		  session[:user_id] = @user.id
		  sign_in @user
		  redirect_to user_steps_path
		else
		  render :new
		end
  end

  def update
    super
  end
end

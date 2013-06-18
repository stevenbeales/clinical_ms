class AppointmentsController < ApplicationController
  before_filter :authorize_parent, :except => [:list, :suggestions_by_department, 
    :suggestions_by_asset_item, :appointment_asset_amount]
  load_and_authorize_resource
  
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Patients", :patients_path, :only => ["new", "edit", "create", "update"]
    
  # GET /appointments
  # GET /appointments.json
  def index
    @patient = Patient.find_by_id(params[:patient_id])
    @practitioner = Practitioner.find_by_id(params[:practitioner_id])
    unless @patient.nil?
      @user = Patient.find(@patient.id) 
      add_crumb "Patients", patients_path
      add_crumb "Appointments for " + @patient.name
    else
      @user = Practitioner.find(@practitioner.id)
      add_crumb "Practitioners", practitioners_path
      add_crumb "Appointments for " + @practitioner.name
    end
    @appointments = @user.appointments.paginate(:page => params[:page], 
      :per_page => Settings.per_page).order("appointment_date desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # this is bs, going out of convention to list appointments
  def list
    add_crumb "Appointments"
    @appointments = Appointment.search {
      fulltext params[:search_text]
      order_by :appointment_date, :desc
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])
    @patient = Patient.find_by_id(params[:patient_id])
    @practitioner = Practitioner.find_by_id(params[:practitioner_id])
    unless @patient.nil?
      add_crumb "Patients", patients_path
      add_crumb "Appointments for " + @patient.name, patient_appointments_path(@patient)
    else
      add_crumb "Practitioners", practitioners_path
      add_crumb "Appointments for " + @practitioner.name, practitioner_appointments_path(@practitioner)      
    end
    add_crumb @appointment.appointment_date.strftime("%d %B %Y ") + 
      @appointment.from_time + " to " + @appointment.to_time

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.json
  def new
    @appointment = Appointment.new
    @patient = Patient.find(params[:patient_id])
    @appointment.patient = @patient
    
    add_crumb "Appointments for " + @patient.name, patient_appointments_path(@patient)
    add_crumb "Create Appointment"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
    @patient = Patient.find(params[:patient_id])
    @appointment.patient = @patient
    
    add_crumb "Appointments for " + @patient.name, patient_appointments_path(@patient)
    add_crumb "Edit Appointment"
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(params[:appointment])
    @patient = Patient.find(params[:patient_id])
    @appointment.patient = @patient
    @appointment.created_by = current_user.id

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to patient_appointment_path(@patient, @appointment), notice: 'Appointment was successfully created.' }
        format.json { render json: @appointment, status: :created, location: @appointment }
      else
        format.html { render :action => :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])
    @patient = Patient.find(params[:patient_id])
    @appointment.patient = @patient
    @appointment.modified_by = current_user.id
    
    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        format.html { redirect_to patient_appointment_path(@patient, @appointment), notice: 'Appointment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end

  def suggestions_by_department
    @errors = "Please Select Department first" if params[:department_id].blank? or 
      params[:department_id].include? "Select"
    @slots = Appointment.practitioners_by_options(params) unless @errors
    respond_to do |format|
      format.js
    end
  end

  def suggestions_by_asset_item
    @errors = "Please Select Asset first" if params[:asset_item_id].blank? or 
      params[:asset_item_id].include? "Select"
    @slots = Appointment.asset_items_by_options(params) unless @errors
    respond_to do |format|
      format.js
    end
  end

  def appointment_asset_amount
    @appointment_asset_amount = AssetItem.find_by_id(params[:asset_item_id]).
      amount(params[:asset_hour_unit].to_f) rescue 0.0
    respond_to do |format|
      format.js
    end
  end

  private
  def authorize_parent
    if params[:patient_id]
      @patient = Patient.find(params[:patient_id])
    elsif params[:practitioner_id]
      @practitioner = Practitioner.find(params[:practitioner_id])
    else
      is_staff = current_user.staff?
    end
    authorize! :read, (@patient || @practitioner || is_staff)
  end
end

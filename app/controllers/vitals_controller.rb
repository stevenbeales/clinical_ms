class VitalsController < ApplicationController
  load_and_authorize_resource

  add_crumb "Dashboard", :dashboard_path
  add_crumb "Patients", :patients_path

  # GET /vitals/1
  # GET /vitals/1.json
  def show
    @appointment = Appointment.find(params[:appointment_id])
    @vital = Vital.find(params[:id])
    add_crumb "Appointments for " + @appointment.patient.name, 
      patient_appointments_path(@appointment.patient)
    add_crumb @vital.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vital }
    end
  end

  # GET /vitals/new
  # GET /vitals/new.json
  def new
    @appointment = Appointment.find(params[:appointment_id])
    @vital = @appointment.build_vital
    add_crumb "Appointments for " + @appointment.patient.name, 
      patient_appointments_path(@appointment.patient)
    add_crumb "New Vital"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vital }
    end
  end

  # GET /vitals/1/edit
  def edit
    @appointment = Appointment.find(params[:appointment_id])
    @vital = Vital.find(params[:id])
    add_crumb "Appointments for " + @appointment.patient.name, 
      patient_appointments_path(@appointment.patient)
    add_crumb "Edit " + @vital.id.to_s
  end

  # POST /vitals
  # POST /vitals.json
  def create
    @appointment = Appointment.find(params[:appointment_id])
    @vital = @appointment.build_vital(params[:vital])

    respond_to do |format|
      if @vital.save
        format.html { redirect_to patient_appointment_vital_path(@appointment.patient, 
          @appointment, @vital), notice: 'Vital was successfully created.' }
        format.json { render json: @vital, status: :created, location: @vital }
      else
        format.html { render action: "new" }
        format.json { render json: @vital.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vitals/1
  # PUT /vitals/1.json
  def update
    @appointment = Appointment.find(params[:appointment_id])
    @vital = Vital.find(params[:id])

    respond_to do |format|
      if @vital.update_attributes(params[:vital])
        format.html { redirect_to patient_appointment_vital_path(@appointment.patient, 
          @appointment, @vital), notice: 'Vital was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vital.errors, status: :unprocessable_entity }
      end
    end
  end
end

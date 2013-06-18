class PractitionersController < ApplicationController
  before_filter :ensure_practitioner_restrictions
  load_and_authorize_resource :except => :practitioners_by_department
  
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Practitioners", :practitioners_path

  # GET /practitioners
  # GET /practitioners.json
  def index
    @practitioners = Practitioner.search { 
      fulltext params[:search_text] 
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @practitioners }
    end
  end

  # GET /practitioners/1
  # GET /practitioners/1.json
  def show
    @practitioner = Practitioner.find(params[:id])
    add_crumb @practitioner.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @practitioner }
    end
  end

  # GET /practitioners/new
  # GET /practitioners/new.json
  def new
    add_crumb "Create Practitioner"
    @practitioner = Practitioner.new
    @practitioner.build_user_profile
    @practitioner.build_department_practitioner

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @practitioner }
    end
  end

  # GET /practitioners/1/edit
  def edit
    @practitioner = Practitioner.find(params[:id])
    add_crumb "Edit " + @practitioner.name
  end

  # POST /practitioners
  # POST /practitioners.json
  def create
    @practitioner = Practitioner.new(params[:practitioner])

    respond_to do |format|
      if @practitioner.save
        format.html { redirect_to @practitioner, notice: 'Practitioner was successfully created.' }
        format.json { render json: @practitioner, status: :created, location: @practitioner }
      else
        format.html { render action: "new" }
        format.json { render json: @practitioner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /practitioners/1
  # PUT /practitioners/1.json
  def update
    @practitioner = Practitioner.find(params[:id])

    respond_to do |format|
      if @practitioner.update_attributes(params[:practitioner])
        format.html { redirect_to @practitioner, notice: 'Practitioner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @practitioner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practitioners/1
  # DELETE /practitioners/1.json
  def destroy
    @practitioner = Practitioner.find(params[:id])
    @practitioner.destroy

    respond_to do |format|
      format.html { redirect_to practitioners_url }
      format.json { head :no_content }
    end
  end

  def practitioners_by_department
    @practitioners = Department.find(params[:department_id]).practitioners
    respond_to do |format|
      format.js
    end
  end

  private
  def ensure_practitioner_restrictions
    if current_user.practitioner?
      authorize! :read, :except => :index
    end
  end
end

class ManagingDirectorsController < ApplicationController
  load_and_authorize_resource
  
  add_crumb "Dashboard", :dashboard_path
  add_crumb "MD", :managing_directors_path

  # GET /managing_directors
  # GET /managing_directors.json
  def index
    @managing_directors = ManagingDirector.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @managing_directors }
    end
  end

  # GET /managing_directors/1
  # GET /managing_directors/1.json
  def show
    @managing_director = ManagingDirector.find(params[:id])
    add_crumb @managing_director.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @managing_director }
    end
  end

  # GET /managing_directors/new
  # GET /managing_directors/new.json
  def new
    add_crumb "Create MD"
    @managing_director = ManagingDirector.new
    @managing_director.build_user_profile

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @managing_director }
    end
  end

  # GET /managing_directors/1/edit
  def edit
    @managing_director = ManagingDirector.find(params[:id])
    add_crumb "Edit " + @managing_director.name
  end

  # POST /managing_directors
  # POST /managing_directors.json
  def create
    @managing_director = ManagingDirector.new(params[:managing_director])

    respond_to do |format|
      if @managing_director.save
        format.html { redirect_to @managing_director, notice: 'Managing director was successfully created.' }
        format.json { render json: @managing_director, status: :created, location: @managing_director }
      else
        format.html { render action: "new" }
        format.json { render json: @managing_director.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /managing_directors/1
  # PUT /managing_directors/1.json
  def update
    @managing_director = ManagingDirector.find(params[:id])

    respond_to do |format|
      if @managing_director.update_attributes(params[:managing_director])
        format.html { redirect_to @managing_director, notice: 'Managing director was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @managing_director.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managing_directors/1
  # DELETE /managing_directors/1.json
  def destroy
    @managing_director = ManagingDirector.find(params[:id])
    @managing_director.destroy

    respond_to do |format|
      format.html { redirect_to managing_directors_url }
      format.json { head :no_content }
    end
  end
end

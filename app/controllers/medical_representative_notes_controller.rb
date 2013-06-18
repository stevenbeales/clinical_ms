class MedicalRepresentativeNotesController < ApplicationController
  before_filter :authorize_parent
  load_and_authorize_resource
  
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Practitioners", :practitioners_path

  # GET /medical_representative_notes
  # GET /medical_representative_notes.json
  def index
    @practitioner = Practitioner.find(params[:practitioner_id])
    @medical_representative_notes = MedicalRepresentativeNote.search {
      fulltext params[:search_text]
      with :practitioner_id, params[:practitioner_id]
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    add_crumb @practitioner.name, practitioner_path(@practitioner)
    add_crumb "Rep Notes"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medical_representative_notes }
    end
  end

  # GET /medical_representative_notes/1
  # GET /medical_representative_notes/1.json
  def show
    @practitioner = Practitioner.find(params[:practitioner_id])
    @medical_representative_note = MedicalRepresentativeNote.find(params[:id])
    add_crumb @practitioner.name, practitioner_path(@practitioner)
    add_crumb "Rep Notes", practitioner_medical_representative_notes_path(@practitioner)
    add_crumb @medical_representative_note.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medical_representative_note }
    end
  end

  # GET /medical_representative_notes/new
  # GET /medical_representative_notes/new.json
  def new
    @practitioner = Practitioner.find(params[:practitioner_id])
    1.times { @medical_representative_note = @practitioner.medical_representative_notes.build }
    add_crumb @practitioner.name, practitioner_path(@practitioner)
    add_crumb "New Rep Note"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medical_representative_note }
    end
  end

  # GET /medical_representative_notes/1/edit
  def edit
    @practitioner = Practitioner.find(params[:practitioner_id])
    @medical_representative_note = MedicalRepresentativeNote.find(params[:id])
    add_crumb @practitioner.name, practitioner_path(@practitioner)
    add_crumb "Rep Notes", practitioner_medical_representative_notes_path(@practitioner)
    add_crumb "Edit " + @medical_representative_note.id.to_s
  end

  # POST /medical_representative_notes
  # POST /medical_representative_notes.json
  def create
    @practitioner = Practitioner.find(params[:practitioner_id])
    1.times { @medical_representative_note = @practitioner.medical_representative_notes.build(params[:medical_representative_note]) }

    respond_to do |format|
      if @medical_representative_note.save
        format.html { redirect_to practitioner_medical_representative_note_path(@practitioner, 
          @medical_representative_note), notice: 'Medical representative note was successfully created.' }
        format.json { render json: @medical_representative_note, status: :created, location: @medical_representative_note }
      else
        format.html { render action: "new" }
        format.json { render json: @medical_representative_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /medical_representative_notes/1
  # PUT /medical_representative_notes/1.json
  def update
    @practitioner = Practitioner.find(params[:practitioner_id])
    @medical_representative_note = MedicalRepresentativeNote.find(params[:id])

    respond_to do |format|
      if @medical_representative_note.update_attributes(params[:medical_representative_note])
        format.html { redirect_to practitioner_medical_representative_note_path(@practitioner, 
          @medical_representative_note), notice: 'Medical representative note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @medical_representative_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_representative_notes/1
  # DELETE /medical_representative_notes/1.json
  def destroy
    @medical_representative_note = MedicalRepresentativeNote.find(params[:id])
    @medical_representative_note.destroy

    respond_to do |format|
      format.html { redirect_to medical_representative_notes_url }
      format.json { head :no_content }
    end
  end

  private
  def authorize_parent
    if params[:practitioner_id]
      @practitioner = Practitioner.find(params[:practitioner_id])
      authorize! :read, @practitioner
    end
  end
end

class CancellationReasonsController < ApplicationController
  load_and_authorize_resource
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Cancellation Reasons", :cancellation_reasons_path
  
  # GET /cancellation_reasons
  # GET /cancellation_reasons.json
  def index
    @cancellation_reasons = CancellationReason.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cancellation_reasons }
    end
  end

  # GET /cancellation_reasons/1
  # GET /cancellation_reasons/1.json
  def show
    @cancellation_reason = CancellationReason.find(params[:id])
    add_crumb @cancellation_reason.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cancellation_reason }
    end
  end

  # GET /cancellation_reasons/new
  # GET /cancellation_reasons/new.json
  def new
    add_crumb "Create Reason"
    @cancellation_reason = CancellationReason.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cancellation_reason }
    end
  end

  # GET /cancellation_reasons/1/edit
  def edit
    @cancellation_reason = CancellationReason.find(params[:id])
    add_crumb "Edit " + @cancellation_reason.name
  end

  # POST /cancellation_reasons
  # POST /cancellation_reasons.json
  def create
    @cancellation_reason = CancellationReason.new(params[:cancellation_reason])

    respond_to do |format|
      if @cancellation_reason.save
        format.html { redirect_to @cancellation_reason, notice: 'Cancellation reason was successfully created.' }
        format.json { render json: @cancellation_reason, status: :created, location: @cancellation_reason }
      else
        format.html { render action: "new" }
        format.json { render json: @cancellation_reason.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cancellation_reasons/1
  # PUT /cancellation_reasons/1.json
  def update
    @cancellation_reason = CancellationReason.find(params[:id])

    respond_to do |format|
      if @cancellation_reason.update_attributes(params[:cancellation_reason])
        format.html { redirect_to @cancellation_reason, notice: 'Cancellation reason was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cancellation_reason.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cancellation_reasons/1
  # DELETE /cancellation_reasons/1.json
  def destroy
    @cancellation_reason = CancellationReason.find(params[:id])
    @cancellation_reason.destroy

    respond_to do |format|
      format.html { redirect_to cancellation_reasons_url }
      format.json { head :no_content }
    end
  end
end

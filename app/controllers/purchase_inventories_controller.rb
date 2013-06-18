class PurchaseInventoriesController < ApplicationController
  load_and_authorize_resource :except => :cost_for_inventory
  
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Inventories", :purchase_inventories_path

  # GET /purchase_inventories
  # GET /purchase_inventories.json
  def index
    @purchase_inventories = PurchaseInventory.search { 
      fulltext params[:search_text] 
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_inventories }
    end
  end

  # GET /purchase_inventories/1
  # GET /purchase_inventories/1.json
  def show
    @purchase_inventory = PurchaseInventory.find(params[:id])
    add_crumb @purchase_inventory.name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase_inventory }
    end
  end

  # GET /purchase_inventories/new
  # GET /purchase_inventories/new.json
  def new
    add_crumb "New Inventory"
    @purchase_inventory = PurchaseInventory.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase_inventory }
    end
  end

  # GET /purchase_inventories/1/edit
  def edit
    @purchase_inventory = PurchaseInventory.find(params[:id])
    add_crumb "Edit " + @purchase_inventory.name
  end

  # POST /purchase_inventories
  # POST /purchase_inventories.json
  def create
    @purchase_inventory = PurchaseInventory.new(params[:purchase_inventory])

    respond_to do |format|
      if @purchase_inventory.save
        format.html { redirect_to @purchase_inventory, notice: 'Purchase inventory was successfully created.' }
        format.json { render json: @purchase_inventory, status: :created, location: @purchase_inventory }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_inventories/1
  # PUT /purchase_inventories/1.json
  def update
    @purchase_inventory = PurchaseInventory.find(params[:id])

    respond_to do |format|
      if @purchase_inventory.update_attributes(params[:purchase_inventory])
        format.html { redirect_to @purchase_inventory, notice: 'Purchase inventory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_inventories/1
  # DELETE /purchase_inventories/1.json
  def destroy
    @purchase_inventory = PurchaseInventory.find(params[:id])
    @purchase_inventory.destroy

    respond_to do |format|
      format.html { redirect_to purchase_inventories_url }
      format.json { head :no_content }
    end
  end

  def cost_for_inventory
    pi = PurchaseInventoriesSupplier.find(params[:inventory_supplier_id])
    @pi_cost = pi.unit_price.to_f * params[:quantity].to_f rescue "0.0"

    respond_to do |format|
      format.json { render json: @pi_cost }
    end
  end
end

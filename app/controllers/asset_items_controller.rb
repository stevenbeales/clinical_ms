class AssetItemsController < ApplicationController
  load_and_authorize_resource
  add_crumb "Dashboard", :dashboard_path
  add_crumb "Asset Items", :asset_items_path

  # GET /asset_items
  # GET /asset_items.json
  def index
    @asset_items = AssetItem.search { 
      fulltext params[:search_text] 
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @asset_items }
    end
  end

  # GET /asset_items/1
  # GET /asset_items/1.json
  def show
    @asset_item = AssetItem.find(params[:id])
    add_crumb @asset_item.decorated_name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asset_item }
    end
  end

  # GET /asset_items/new
  # GET /asset_items/new.json
  def new
    add_crumb "Create Item"
    @asset_item = AssetItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset_item }
    end
  end

  # GET /asset_items/1/edit
  def edit
    @asset_item = AssetItem.find(params[:id])
    add_crumb "Edit " + @asset_item.decorated_name
  end

  # POST /asset_items
  # POST /asset_items.json
  def create
    @asset_item = AssetItem.new(params[:asset_item])

    respond_to do |format|
      if @asset_item.save
        format.html { redirect_to @asset_item, notice: 'Asset item was successfully created.' }
        format.json { render json: @asset_item, status: :created, location: @asset_item }
      else
        format.html { render action: "new" }
        format.json { render json: @asset_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /asset_items/1
  # PUT /asset_items/1.json
  def update
    @asset_item = AssetItem.find(params[:id])

    respond_to do |format|
      if @asset_item.update_attributes(params[:asset_item])
        format.html { redirect_to @asset_item, notice: 'Asset item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asset_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset_items/1
  # DELETE /asset_items/1.json
  def destroy
    @asset_item = AssetItem.find(params[:id])
    @asset_item.destroy

    respond_to do |format|
      format.html { redirect_to asset_items_url }
      format.json { head :no_content }
    end
  end
end

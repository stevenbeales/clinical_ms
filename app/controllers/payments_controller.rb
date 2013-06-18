class PaymentsController < ApplicationController
  before_filter :authorize_parent, :except => [:print_receipt, :list]
  load_and_authorize_resource

  add_crumb "Dashboard", :dashboard_path
  
  # GET /payments
  # GET /payments.json
  def index
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
      add_crumb "Patients", patients_path
    else
      @user = Supplier.find(params[:supplier_id])
      add_crumb "Suppliers", suppliers_path
    end
    add_crumb "Payments for " + @user.name

    @payments = @user.payments.order("created_at desc").uniq.paginate(:page => params[:page], 
      :per_page => Settings.per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
      add_crumb "Patients", patients_path
      add_crumb "Payments for " + @user.name, patient_payments_path(@user)
    else
      @user = Supplier.find(params[:supplier_id])
      add_crumb "Suppliers", suppliers_path
      add_crumb "Payments for " + @user.name, supplier_payments_path(@user)
    end
    add_crumb @payment.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
      add_crumb "Patients", patients_path
      add_crumb "Payments for " + @user.name, patient_payments_path(@user)
      @payment.build_appointment_payment_items(@user.id, 0.0)
    else
      @user = Supplier.find(params[:supplier_id])
      add_crumb "Suppliers", suppliers_path
      add_crumb "Payments for " + @user.name, supplier_payments_path(@user)
      @payment.build_purchase_payment_items(@user.id, 0.0)
    end
    add_crumb "New Payment"
    
    @payment.set_amount_and_discount

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
      add_crumb "Patients", patients_path
      add_crumb "Payments for " + @user.name, patient_payments_path(@user)
    else
      @user = Supplier.find(params[:supplier_id])
      add_crumb "Suppliers", suppliers_path
      add_crumb "Payments for " + @user.name, supplier_payments_path(@user)
    end
    add_crumb @payment.id.to_s
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
    else
      @user = Supplier.find(params[:supplier_id])
    end
    @payment.created_by = current_user.id

    respond_to do |format|
      if @payment.save
        redirect_path = params[:patient_id] ? patient_payment_path(@user, @payment) : 
          supplier_payment_path(@user, @payment)
        format.html { redirect_to redirect_path, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])
    if params[:patient_id]
      @user = Patient.find(params[:patient_id])
    else
      @user = Supplier.find(params[:supplier_id])
    end
    @payment.modified_by = current_user.id

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        redirect_path = params[:patient_id] ? patient_payment_path(@user, @payment) : 
          supplier_payment_path(@user, @payment)
        format.html { redirect_to redirect_path, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end

  def print_receipt
    @payment = Payment.find(params[:payment_id])
    render :layout => false
  end

  def list
    add_crumb "Payments"
    @payments = Payment.search {
      fulltext params[:search_text]
      order_by :created_at, :desc
      paginate :page => params[:page], :per_page => Settings.per_page
    }.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  private
  def authorize_parent
    if params[:patient_id]
      @patient = Patient.find(params[:patient_id])
    elsif params[:supplier_id]
      @supplier = Supplier.find(params[:supplier_id])
    else
      is_staff = current_user.staff?
    end
    authorize! :read, (@patient || @supplier || is_staff)
  end
end

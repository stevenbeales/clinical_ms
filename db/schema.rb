# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130617122604) do

  create_table "appointments", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "department_id"
    t.integer  "practitioner_id"
    t.date     "appointment_date"
    t.string   "from_time"
    t.string   "to_time"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "status"
    t.integer  "cancellation_reason_id"
    t.integer  "created_by"
    t.integer  "modified_by"
    t.integer  "asset_item_id"
    t.float    "asset_hour_unit"
    t.float    "amount"
  end

  create_table "asset_items", :force => true do |t|
    t.integer  "asset_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "serial_number"
  end

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.integer  "clinic_id"
    t.integer  "hour_unit"
    t.float    "cost"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cancellation_reasons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clinics", :force => true do |t|
    t.string   "name"
    t.integer  "phone"
    t.string   "work_from_time"
    t.string   "work_to_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "address"
  end

  create_table "department_practitioners", :force => true do |t|
    t.integer  "department_id"
    t.integer  "practitioner_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "clinic_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "medical_representative_notes", :force => true do |t|
    t.integer  "practitioner_id"
    t.string   "rep_name"
    t.string   "rep_company"
    t.integer  "rep_phone"
    t.string   "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "patient_histories", :force => true do |t|
    t.string   "consultant_name"
    t.string   "consultant_clinic_name"
    t.integer  "consultant_phone_no"
    t.string   "symptoms"
    t.string   "medication"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "follow_up"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "patient_id"
  end

  create_table "patient_profiles", :force => true do |t|
    t.integer  "patient_id"
    t.string   "uid"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "emergency_contact_names"
    t.string   "emergency_contact_nos"
  end

  create_table "payment_items", :force => true do |t|
    t.integer  "payment_id"
    t.integer  "transaction_id"
    t.string   "transaction_type"
    t.float    "amount"
    t.float    "discount"
    t.string   "discount_note"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "payments", :force => true do |t|
    t.float    "amount"
    t.float    "paid_amount"
    t.float    "discount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "created_by"
    t.integer  "modified_by"
  end

  create_table "purchase_inventories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "purchase_inventories_suppliers", :force => true do |t|
    t.integer  "purchase_inventory_id"
    t.integer  "supplier_id"
    t.float    "unit_price"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "status"
  end

  create_table "purchase_order_items", :force => true do |t|
    t.integer  "purchase_order_id"
    t.integer  "quantity"
    t.float    "cost"
    t.integer  "purchase_inventories_supplier_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "purchase_orders", :force => true do |t|
    t.integer  "quantity"
    t.float    "amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "created_by"
    t.integer  "modified_by"
  end

  create_table "user_profiles", :force => true do |t|
    t.string   "name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "phone"
    t.string   "address"
  end

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "user_role_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vitals", :force => true do |t|
    t.integer  "appointment_id"
    t.string   "height"
    t.string   "weight"
    t.string   "blood_pressure"
    t.string   "sugar_level"
    t.string   "temperature"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end

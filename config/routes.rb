ClinicalMs::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :user_steps
  
  resources :user_profiles, :except => [:index, :destroy]
  resources :clinics, :departments, :cancellation_reasons, :assets, :asset_items, 
  	:purchase_inventories, :purchase_orders

	match "appointments/list" => "appointments#list"
	match "suggestions_by_department" => "appointments#suggestions_by_department"
	match "suggestions_by_asset_item" => "appointments#suggestions_by_asset_item"
	match "appointment_asset_amount" => "appointments#appointment_asset_amount"

	match "print_receipt" => "payments#print_receipt"	
	match "payments/list" => "payments#list"
	match "patients/histories" => "patients#histories"

	resources :patients do
		resources :appointments do
  		resources :vitals, :except => [:index, :destroy]
  	end
		resources :payments
  	resources :patient_histories
	end

	resources :practitioners do
		resources :appointments, :only => [:index, :show]
  	resources :medical_representative_notes
	end

	resources :staffs, :managing_directors

	resources :suppliers do
		resources :payments
	end
	
	match "practitioners_by_department" => "practitioners#practitioners_by_department"
	match "cost_for_inventory" => "purchase_inventories#cost_for_inventory"

  # This should be the last line in routes
	match "dashboard" => "dashboard#index"  
  root :to => "dashboard#index"
end

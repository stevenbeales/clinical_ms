class AddCancellationAndUsersToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :cancellation_reason_id, :integer
    add_column :appointments, :created_by, :integer
    add_column :appointments, :modified_by, :integer
  end
end

class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :amount
      t.float :paid_amount
      t.float :discount

      t.timestamps
    end
  end
end

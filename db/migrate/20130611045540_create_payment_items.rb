class CreatePaymentItems < ActiveRecord::Migration
  def change
    create_table :payment_items do |t|
      t.integer :payment_id
      t.integer :transaction_id
      t.string :transaction_type
      t.float :amount
      t.float :discount
      t.string :discount_note

      t.timestamps
    end
  end
end

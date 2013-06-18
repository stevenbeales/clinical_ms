class CreateCancellationReasons < ActiveRecord::Migration
  def change
    create_table :cancellation_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end

class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :name
      t.string :gender
      t.date :date_of_birth
      t.integer :user_id

      t.timestamps
    end
  end
end

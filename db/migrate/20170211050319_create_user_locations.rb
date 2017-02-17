class CreateUserLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_locations do |t|
      t.integer :user_id, null: false
      t.inet :ip, null: false
      t.float :latitude
      t.float :longitude
      t.string :address

      t.timestamps
    end

    add_index :user_locations, :user_id
  end
end

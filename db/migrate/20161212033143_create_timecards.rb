class CreateTimecards < ActiveRecord::Migration[5.0]
  def change
    create_table :timecards do |t|
    	t.datetime :stop_time
    	t.integer :user_id, null: false

      t.timestamps
    end
  end
end

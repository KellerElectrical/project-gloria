class CreateTimecardJoins < ActiveRecord::Migration[5.0]
  def change
    create_table :timecard_joins do |t|
      t.integer :timecard_id, null: false
      t.integer :task_id, null: false
      t.float :task_hours

      t.timestamps
    end
  end
end

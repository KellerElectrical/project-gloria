class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
    	t.integer :job_id
    	t.string :type
    	t.datetime :scheduled_time
    	t.integer :quantity

      t.timestamps
    end

    add_index :tasks, :job_id
  end
end

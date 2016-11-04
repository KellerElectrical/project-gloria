class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
    	t.integer :job_number

      t.timestamps
    end
    add_index :jobs, :job_number, unique: true
  end
end

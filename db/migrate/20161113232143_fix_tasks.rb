class FixTasks < ActiveRecord::Migration[5.0]
  def change
  	rename_column :tasks, :man_hours, :hours
  	add_column :tasks, :user_id, :integer, null: false
  	add_index :tasks, :user_id
  	add_column :tasks, :comments, :text
  end
end

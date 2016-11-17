class AddColumnBidtaskIdToTasks < ActiveRecord::Migration[5.0]
  def change
  	remove_column :tasks, :bid, :boolean
  	add_column :tasks, :bidtask_id, :integer, default: 0, null: false
  	add_index :tasks, :bidtask_id
  end
end

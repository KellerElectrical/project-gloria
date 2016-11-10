class AddBidToTasks < ActiveRecord::Migration[5.0]
  def change
  	add_column :tasks, :bid, :boolean, default: false
  end
end

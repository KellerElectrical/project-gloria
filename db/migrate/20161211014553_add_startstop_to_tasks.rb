class AddStartstopToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :starttime, :datetime
    add_column :tasks, :stoptime, :datetime
  end
end

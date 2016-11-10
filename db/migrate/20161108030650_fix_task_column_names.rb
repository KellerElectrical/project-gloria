class FixTaskColumnNames < ActiveRecord::Migration[5.0]
  def change
  	rename_column :tasks, :type, :name
  	remove_column :tasks, :scheduled_time, :datetime
  	add_column :tasks, :man_hours, :float
  	remove_column :tasks, :quantity, :integer
  	add_column :tasks, :quantity, :float
  	add_column :tasks, :quantity_units, :string
  end
end

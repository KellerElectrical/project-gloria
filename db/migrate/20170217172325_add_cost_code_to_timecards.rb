class AddCostCodeToTimecards < ActiveRecord::Migration[5.0]
  def change
  	add_column :timecards, :cost_code, :string
  end
end

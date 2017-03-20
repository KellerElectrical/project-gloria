class AddConfirmedToTimecards < ActiveRecord::Migration[5.0]
  def change
    add_column :timecards, :confirmed, :boolean, default: false
  end
end

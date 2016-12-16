class AddTeamMembersToTimecards < ActiveRecord::Migration[5.0]
  def change
    add_column :timecards, :team_members, :string
  end
end

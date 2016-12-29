class Timecard < ApplicationRecord
	belongs_to :user
	has_many :timecard_joins
	has_many :tasks, through: :timecard_joins
	accepts_nested_attributes_for :tasks

	def get_clock
		stoptime = (self.stop_time.nil? ? Time.now : self.stop_time.time)
		Time.at(stoptime - self.created_at.time).gmtime.strftime('%R:%S')
	end

	def get_rounded_hours
		return 0 if self.stop_time.nil?
		t = Time.at(self.stop_time.time - self.created_at.time).gmtime
		decimal = t.hour + t.min / 60.0
		(decimal * 4).round / 4.0
	end

	def num_members
		return 1 if self.team_members.nil?
		self.team_members.split(",").size
	end
end

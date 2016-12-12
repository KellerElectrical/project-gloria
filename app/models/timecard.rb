class Timecard < ApplicationRecord
	belongs_to :user
	has_many :timecard_joins
	has_many :tasks, through: :timecard_joins

	def get_clock
		stoptime = (self.stop_time.nil? ? Time.now : self.stop_time.time)
		Time.at(stoptime - self.created_at.time).gmtime.strftime('%R:%S')
	end

	def get_rounded_hours
		return 0 if self.stop_time.nil?
		(Time.at(self.stop_time.time - self.created_at.time) + 30.minutes).beginning_of_hour.gmtime.strftime("%H").to_i
	end
end

class TimecardJoin < ApplicationRecord
	belongs_to :timecard
	belongs_to :task
end

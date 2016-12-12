class Job < ApplicationRecord
	has_many :tasks

	def bidtasks
		self.tasks.where(bidtask_id: 0).order(:id)
	end
end

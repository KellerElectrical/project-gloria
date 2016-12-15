class Job < ApplicationRecord
	has_many :tasks

	def bidtasks
		self.tasks.where(bidtask_id: 0).order(:id)
	end

	def get_name
		"Job #{self.job_number}"
	end
end

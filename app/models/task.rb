class Task < ApplicationRecord
	belongs_to :job
	belongs_to :user
	has_many :actual_tasks, class_name: "Task", foreign_key: "bidtask_id"
	belongs_to :bidtask, class_name: "Task", required: false
	has_many :timecard_joins
	has_many :timecards, through: :timecard_joins

	validates :user_id, :job_id, presence: true
	#TODO: add validators for all models

	def get_actual_total(total_type) # :hours or :quantity
		return nil unless self.bidtask_id == 0
		sum = self.actual_tasks.sum(total_type)
	end
end
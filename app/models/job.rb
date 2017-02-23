class Job < ApplicationRecord
	has_many :tasks

	def bidtasks
		self.tasks.where(bidtask_id: 0).order(:id)
	end

	def get_name
		"Job #{self.job_number}"
	end

	def self.find_or_create_by_name(jobname)
		jobname.strip!
		# Possible job #
		if !!(jobname =~ /^[Jj]ob[\D]*\d+$/) || !!(jobname =~ /^(\d)+$/)
			num = /(\d)+$/.match(jobname)[0].to_i
			j = Job.find_by_job_number(num)
			return (j.nil? ? Job.create(job_number: num) : j)
		else
			j = Job.find_by_name(jobname)
			return (j.nil? ? Job.create(name: jobname) : j)
		end
	end
end

class TasksController < ApplicationController
	def create
		@job = Job.find(params[:job_id])
		if @job.nil?
			redirect_to root_url
		else
			@job.tasks.create({type: params[:type]})
			if @job.save
				redirect_to job_url(@job)
			else
				redirect_to root_url
			end
		end
	end
end

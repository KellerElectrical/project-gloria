class JobsController < ApplicationController
	def show
		@job = Job.find(params[:id])
		if @job.nil?
			flash[:errors] = "Job not found"
		else
			@task = Task.new
			render :show
		end
	end
end

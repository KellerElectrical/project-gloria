class JobsController < ApplicationController

	def show
		@job = Job.find(params[:id])
		if @job.nil?
			flash[:errors] = "Job not found"
		else
			@bidtasks = @job.tasks.where(bidtask_id: 0).order(:id)
			@task = Task.new
			render (current_user.admin? ? :show_admin : :show)
		end
	end

	def new
		redirect_to root_url unless current_user.admin?
		@job = Job.new
		render :new
	end

	def create
		@job = Job.create(params.require(:job).permit(:job_number))
		if @job.save
			redirect_to job_url(@job)
		else
			redirect_to root_url
		end
	end
end

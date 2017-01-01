class JobsController < ApplicationController

	before_action :check_signed_in, only: [:show, :new, :create, :get_tasks]

	def show
		@job = Job.find(params[:id])
		if @job.nil?
			flash[:errors] = "Job not found"
		else
			@bidtasks = @job.bidtasks
			@task = Task.new
			render :show
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

	def get_tasks
		# TODO: authenticate
		@job = Job.find(params[:id])
	  respond_to do |format|
	  	# JSON object:
	  	#[{\"id\":7,\"name\":\"sdfklsd\"},{\"id\":8,\"name\":\"Working\"},{\"id\":24,\"name\":\"console add\"}]"
	    msg = @job.bidtasks.to_json(only: [:id, :name])
	    format.json  { render :json => msg } # don't do msg.to_json
	  end
	end
end

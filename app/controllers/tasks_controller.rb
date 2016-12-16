class TasksController < ApplicationController


	def create
		@job = Job.find(params[:task][:job_id])
		if @job.nil?
			redirect_to root_url
		else
			job = @job.tasks.create(task_params)
			if job.save
				redirect_to job_url(@job)
			else
				redirect_to root_url
			end
		end
	end

	def update
		@task = Task.find(params[:id])
		if @task.nil?
			redirect_to root_url
		else
			@task.update_attributes(task_params)
			redirect_to job_url(@task.job_id)
		end
	end

	def destroy
		@task = Task.find(params[:id])
		id = @task.job_id
		@task.destroy
		redirect_to job_url(id)
	end

	private
	def task_params
		params.require(:task).permit(:name, :hours, :quantity, :quantity_units, :user_id, :bidtask_id, :comments)
	end
end

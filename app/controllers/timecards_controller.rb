class TimecardsController < ApplicationController

	def show
		@timecard = Timecard.find(params[:id])
		render :show
	end

	def new
		timecard = current_user.get_todays_timecard
		if !timecard.nil? && timecard.tasks.empty?
			redirect_to edit_timecard_url(timecard)
		else
			@timecard = Timecard.new
			@timecards = current_user.timecards
			render :new
		end
	end

	def create
		@timecard = Timecard.create({user_id: current_user.id})
		redirect_to timecard_url(@timecard)
	end

	def edit
		@timecard = Timecard.find(params[:id])
		if @timecard.user_id != current_user.id
			redirect_to root_url 
		else
			@actual = Task.new
			@jobs = Job.all.select{|j| !j.tasks.empty? }
			render :edit
		end
	end

	def update
		@timecard = Timecard.find(params[:id])
		if params[:stop] == "true"
			@timecard.update_attributes({stop_time: DateTime.now})
			redirect_to edit_timecard_url(@timecard)
		else
			task = Task.where(id: params[:timecard][:task_ids]).first
			# TODO: redesign edit page to allow multiple actuals posting
			new_actual = task.actual_tasks.create(task_params)
				#join task to timecard
			TimecardJoin.create({timecard_id: @timecard.id, task_id: new_actual.id})

		end
	end

	def task_params
		params.require(:task).permit(:name, :hours, :quantity, :quantity_units, :user_id, :bidtask_id, :comments, :job_id)
	end
end

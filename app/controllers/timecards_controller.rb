class TimecardsController < ApplicationController
	before_action :restrict_to_admin, only: [:index]


	def show
		@timecard = Timecard.find(params[:id])
		render :show
	end

	def index
		@users = User.all.select{|u| !u.confirmed_at.nil? }
		render :index
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
			members = params.require(:timecard).require("team_members").join(",")
			@timecard.update_attributes({stop_time: DateTime.now, team_members: members})
			redirect_to edit_timecard_url(@timecard)
		else
			timecard_params_array.each do |param|
				new_actual = Task.new(permit_task param)
				new_actual.hours *= @timecard.num_members
				if new_actual.save
					TimecardJoin.create({timecard_id: @timecard.id, task_id: new_actual.id})
				else
					redirect_to edit_timecard_url(@timecard)
					return
				end
			end
			redirect_to new_timecard_url
		end
	end

	private
	def timecard_params_array
		params.require(:timecard).transform_keys{|k| k = k.to_sym }.require(:task_attrs)
	end

	def restrict_to_admin
		redirect_to root_url unless current_user.admin?
	end

	# params.require(:timecard).permit(:task_attrs).tap do |timecard_params|
 #    timecard_params.require("task_attrs") # SAFER
 #  end

	def permit_task(param)
		param.permit(:name, :hours, :quantity, :quantity_units, :user_id, :bidtask_id, :comments, :job_id)
	end
end

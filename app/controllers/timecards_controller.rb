class TimecardsController < ApplicationController
	before_action :restrict_to_admin, only: [:index]

	def show
		@timecard = Timecard.find(params[:id])
		render :show
	end

	def index
		if params[:user_id]
			@user = User.find(params[:user_id])
			if @user
				render :user_index
			else
				redirect_to root_url
			end
		else
			@users = User.all.select{|u| !u.confirmed_at.nil? }
			render :index
		end
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
		redirect_to root_url and return unless user_signed_in?
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
			redirect_to cost_code_url(@timecard)

		elsif params[:costcode] == "true"

			@timecard.update_attributes({cost_code: params[:timecard][:cost_code]})
			redirect_to edit_timecard_url(@timecard)

		else
			if @timecard.cost_code == "Construction"

				timecard_params_array.each do |param|
					new_actual = Task.new(permit_task param)
					if new_actual.save
						TimecardJoin.create({timecard_id: @timecard.id, task_id: new_actual.id})
					else
						redirect_to edit_timecard_url(@timecard)
						return
					end
				end
				redirect_to new_timecard_url

			else
				parms = params.require(:timecard).transform_keys{|k| k = k.to_sym }.require(:job_attrs)[0]
				new_job = Job.find_or_create_by_name(parms[:name])
				new_actual = Task.new({job_id: new_job.id, comments: parms[:comments], name: new_job.name, user_id: parms[:user_id], hours: parms[:hours]})
				if new_actual.save
					TimecardJoin.create({timecard_id: @timecard.id, task_id: new_actual.id})

				else
					redirect_to edit_timecard_url(@timecard)
					return
				end

				redirect_to new_timecard_url
			end
		end
	end

	def show_user_weeks
		@user = User.find params[:user_id]
		unless @user.nil?
			@weeks = []
			unless @user.timecards.empty?
				day = @user.timecards.last.created_at
				wk = get_user_week(@user, day)
				until day.month == 11 && day.year == 2016
					@weeks << wk unless wk.nil?
					wk = get_user_week(@user, day -= 1.week)
				end
			end
			render :show_weeks
		else
			redirect_to root_url
		end
	end

	def get_user_week(user, day)
		timecards = user.get_weeks_timecard(day)
		if timecards.empty?
			return nil
		else
			# Organize by {job1: {costcode: , totals: [1.5, 0, ... 0], comments: "", confirmed: , team_members, ""}, job2:  }
			hsh = {}
			timecards.each do |tc|
				tc.tasks.each do |task|
					next if task.job_id == 0
					job = Job.find(task.job_id)
					key = job.name || job.job_number.to_s
					hsh[key] ||= {costcode: (tc.cost_code || "N/A"), totals: [0] * 7, comments: task.comments, confirmed: tc.confirmed, team_members: tc.team_members}
					hsh[key][:totals][tc.created_at.wday] += task.hours
				end
			end
			rows = [] # 2d array with [jobname, costcode, 7 day values, and 1 total, and comments]
			hsh.each do |jobname, jobhash|
					arr = jobhash[:totals]
					row = []
					row << jobname
					row << jobhash[:costcode]
					row.concat(arr[0..6])
					row << arr[0..6].sum
					row << jobhash[:comments]
					row << jobhash[:confirmed]
					row << jobhash[:team_members]
					rows << row
			end
			return nil if rows.empty?
			{day: day, rows: rows}
		end
	end

	def send_week_email
		user = User.find(params[:user_id])
		params[:emails].split(",").each do |email|
			wk = get_user_week(user, datetime_from_param(params[:day]))
			# only send individually for now TODO: allow multiple
			TimecardMailer.send_weeks(email, user, [wk]).deliver_now
		end
		redirect_to user_weeks_url(user)
	end

	def download_week_csv
		day = (DateTime.now - 2.days)
		sunday = day.beginning_of_week - 1.day
		if params[:user_id] == "all_users"
			timestr = "#{sunday.strftime("%-m-%-d")}_#{(sunday + 6.days).strftime("%-m-%-d")}"
			fn = "all_users_#{timestr}.csv"
			file = generate_csv(User.order(:email), day, fn)
			File.open(fn, 'r') do |f|
				send_data(f.read, filename: fn, type: "application/csv")
			end
		  File.delete fn
		else
			user = User.find(params[:user_id])
			sunday = datetime_from_param(params[:day]).beginning_of_week - 1.day
			timestr = "#{sunday.strftime("%-m-%-d")}_#{(sunday + 6.days).strftime("%-m-%-d")}"
			fn = "#{user.email.split("@").first}_#{timestr}.csv"
			file = generate_csv([user], day, fn)
			File.open(fn, 'r') do |f|
				send_data(f.read, filename: fn, type: "application/csv")
			end
		  File.delete fn
		end
	end

	def confirm_week
		@user = User.find(params[:user_id])
		tc = @user.get_weeks_timecard(DateTime.parse params[:day])
		tc.each do |tc|
			tc.confirmed = true
			tc.save
		end
		render :confirmed
	end

	def cost_code
		@timecard = Timecard.find(params[:id])
		render :cost_code
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

	def datetime_from_param(param)
		DateTime.strptime(param, '%Y-%m-%d %H:%M:%S %Z')
	end

  def generate_csv(users, day, fn)
  	sunday = day.beginning_of_week - 1.day
    CSV.open(fn, "wb") do |csv|
    	users.each do |user|
    		csv << [user.email]
	    	wk = get_user_week(user, day)
	    	unless wk.nil?
		    	header = ["Job Name", "Cost Code"]
		    	7.times do |i|
						dt = sunday + i.days
						header << dt.strftime("%a %-m/%-d")
		    	end
		    	header << "Total"
		    	header << "Comments"
		    	header << "Confirmed"
		    	header << "Team Members"
		    	csv << header

		    	wk[:rows].each {|row|	csv << row }
	    	end
	    	csv << [""]
	    end
    	csv
    end
  end

end

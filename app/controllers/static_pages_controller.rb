class StaticPagesController < ApplicationController
	before_action :authenticate

	def index
		@jobs = Job.all
		if current_user.admin?
			render :admin_index
		else
			timecard = current_user.get_todays_timecard
			if timecard.nil?
				redirect_to new_timecard_url
			elsif timecard.stop_time.nil?
				redirect_to timecard_url(timecard)
			elsif timecard.tasks.empty?
				redirect_to edit_timecard_url(timecard)
			else
				redirect_to new_timecard_url
			end
		end
	end

	private
	def authenticate
		redirect_to new_user_session_url unless user_signed_in?
	end

end

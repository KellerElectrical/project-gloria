class StaticPagesController < ApplicationController
	before_action :authenticate

	def index
		@jobs = Job.all
		if current_user.admin?
			render :admin_index
		else
			render :index
		end
	end

	private
	def authenticate
		redirect_to new_user_session_url unless user_signed_in?
	end

end

class StaticPagesController < ApplicationController
	before_action :authenticate

	def index
		@users = User.all
		render :index
	end

	private
	def authenticate
		redirect_to new_user_session_url unless user_signed_in?
	end

end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  
  def check_signed_in
		redirect_to new_session_url unless user_signed_in?
	end

end

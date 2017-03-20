class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception



  def check_signed_in
		redirect_to new_session_url unless user_signed_in?
	end

	def zone(datetime)
  	datetime.in_time_zone("Arizona")
  end

  def admin_db_clear
  	if current_user.admin?
  		Job.delete_all
  		Task.delete_all
  		Timecard.delete_all
  		TimecardJoin.delete_all
      UserLocation.delete_all

	  	respond_to do |format|
	      format.json { render json: {"Success": "Successful"}, status: 200}
	    end
	  end
  end

  def update_user_admin
    if current_user.admin?
      user = User.find(params[:id])
      user.update_attributes(admin: (params[:user][:admin] == "1"))
      redirect_to root_url
    end
	end

end

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
      construction_jobs = Job.all.select{|j| j.tasks.select{|t| User.where(admin: true).pluck(:id).include? t.user_id }.size > 0 }.pluck(:id)
      Job.where.not(id: construction_jobs).delete_all
      construction_tasks = Task.where(job_id: construction_jobs)
  		Task.where.not(id: construction_tasks.pluck(:id)).delete_all
      construction_timecards = construction_tasks.map{|t| t.timecards.pluck(:id)}.flatten
  		Timecard.where.not(id: construction_timecards).delete_all
  		TimecardJoin.where.not(task_id: construction_tasks.pluck(:id)).where.not(timecard_id: construction_timecards).delete_all
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

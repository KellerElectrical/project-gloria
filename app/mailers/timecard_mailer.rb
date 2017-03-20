class TimecardMailer < ApplicationMailer
	def send_weeks(email, user, weeks)
		@user = user
		@weeks = weeks
		start = weeks.last[:day]
		finish = weeks.first[:day] + 6.days
		timestr = "#{start.strftime("%-m/%-d")}-#{finish.strftime("%-m/%-d")}"
		mail(to: email, subject: "Timecards for #{user.email}, #{timestr}")
	end

  def send_all_weeks(email)
    @users = User.order(:email)
    @weeks = []
    @users.each do |user|
      @weeks << get_user_week(user, DateTime.now)
    end
    start = weeks.last[:day]
    finish = weeks.first[:day] + 6.days
    timestr = "#{start.strftime("%-m/%-d")}-#{finish.strftime("%-m/%-d")}"
    mail(to: email, subject: "Timecards for all users, #{timestr}")
  end
end

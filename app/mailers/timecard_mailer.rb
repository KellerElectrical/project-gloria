class TimecardMailer < ApplicationMailer
	def send_weeks(email, user, weeks)
		@user = user
		@weeks = weeks
    timestr = ""
    if weeks.last.nil? || weeks.first.nil?
      timestr = DateTime.now.strftime("%-m/%-d")
    else
  		start = weeks.last[:day]
  		finish = weeks.first[:day] + 6.days
  		timestr = "#{start.strftime("%-m/%-d")}-#{finish.strftime("%-m/%-d")}"
		end
    mail(to: email, subject: "Timecards for #{user.email}, #{timestr}")
	end

  def send_all_weeks(email)
    @users = User.order(:email)
    @weeks = []
    @users.each do |user|
      @weeks << user.get_user_week(DateTime.now - 2.days)
    end

    sunday = (DateTime.now - 2.days).beginning_of_week - 1.day
    timestr = "#{sunday.strftime("%-m-%-d")}_#{(sunday + 6.days).strftime("%-m-%-d")}"
    fn = "all_users_#{timestr}.csv"
    file = generate_csv(User.order(:email), sunday, fn)
    attachments[fn] = File.read(fn)
    timestr = DateTime.now.strftime("%-m/%-d")
    mail(to: email, subject: "Timecards for all users, #{timestr}")
    File.delete fn
  end

  def generate_csv(users, sunday, fn)
    CSV.open(fn, "wb") do |csv|
      users.each do |user|
        csv << [user.email]
        wk = user.get_user_week(sunday)
        unless wk.nil?
          header = ["Job Name", "Cost Code"]
          7.times do |i|
            dt = sunday + i.days
            header << dt.strftime("%a %-m/%-d")
          end
          header << "Total"
          header << "Comments"
          csv << header

          wk[:rows].each {|row| csv << row }
        end
        csv << [""]
      end
      csv
    end
  end
end

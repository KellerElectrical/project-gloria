namespace :email do 
  desc "Emails csv of all users timecards, past 7 days"
  task :timecards => :environment do 
    if DateTime.now.in_time_zone("Arizona").wday == 1
      TimecardMailer.send_all_weeks("kturille@kellerelectrical.com").deliver_now
      TimecardMailer.send_all_weeks("ewpeters@asu.edu").deliver_now
    end
  end
  task :timecards_confirm => :environment do
    day = DateTime.now.in_time_zone("Arizona")
    if day.wday == 5
      User.all.each do |user|
        wk = user.get_user_week(day)
        next if wk.nil?

        TimecardMailer.send_weeks(user.email, user, [wk], true).deliver_now
      end
    end
  end
end
namespace :email do 
  desc "Emails csv of all users timecards, past 7 days"
  task :timecards => :environment do 


      TimecardMailer.send_all_weeks("ewpeters@asu.edu").deliver_now

  end
  task :timecards_confirm => :environment do
    User.all.each do |user|
      wk = user.get_user_week(DateTime.now)
      next if wk.nil?

      TimecardMailer.send_weeks(user.email, user, [wk], true).deliver_now
    end
  end
end
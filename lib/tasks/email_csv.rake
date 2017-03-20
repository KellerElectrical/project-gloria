namespace :email do 
  desc "Emails csv of all users timecards, past 7 days"
  task :timecards do 


      TimecardMailer.send_all_weeks("ewpeters@asu.edu").deliver_now

  end
end
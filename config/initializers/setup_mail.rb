ActionMailer::Base.smtp_settings = {
   :address => "smtp.sendgrid.net",
   :user_name => ENV["SENDGRID_USERNAME"],
   :password => ENV["SENDGRID_PASSWORD"],
   :domain => "sendgrid.net",
   

   :port => 587,
   :authentication => "plain",
   :enable_starttls_auto => true
 }
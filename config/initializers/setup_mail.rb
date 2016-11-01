ActionMailer::Base.smtp_settings = {
   :address => "smtp.sendgrid.net",
   :port => 587,
   :domain => "sendgrid.net",
   :user_name => ENV["SENDGRID_USERNAME"],
   :password => ENV["SENDGRID_PASSWORD"],
   :domain => "sendgrid.net",
   :authentication => "plain",
   :enable_starttls_auto => true
 }
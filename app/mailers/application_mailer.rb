class ApplicationMailer < ActionMailer::Base
  default from: 'admin@project-gloria.herokuapp.com'
  layout 'mailer'
end

class ApplicationMailer < ActionMailer::Base
  default from: Settings.email
  layout 'mailer'
end

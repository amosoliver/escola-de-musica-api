class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_USERNAME", ENV.fetch("DEVISE_MAILER_SENDER", "no-reply@escolademusica.local"))
  layout "mailer"
end

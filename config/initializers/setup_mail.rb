ActionMailer::Base.smtp_settings = {
  :address              => SecretSetting.mail.address,
  :port                 => SecretSetting.mail.port,
  :domain               => SecretSetting.mail.domain,
  :user_name            => SecretSetting.mail.user_name,
  :password             => SecretSetting.mail.password,
  :authentication       => :plain,
  :enable_starttls_auto => false
}

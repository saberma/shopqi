ActionMailer::Base.smtp_settings = {
  :address              => "smtp.163.com",
  :port                 =>  25,
  :domain               => "shopqi.com",
  :user_name            => "shopqi_test@163.com",
  :password             => "666666",
  :authentication       => "plain",
  :enable_starttls_auto => false
}


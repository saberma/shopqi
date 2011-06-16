ActionMailer::Base.smtp_settings = {
  :address              => "smtp.163.com",
  :port                 =>  25,
  :domain               => "shopqi.com",
  :user_name            => "shopqi_test@163.com",
  :password             => "666666",
  :authentication       => "plain",
  :enable_starttls_auto => false
}

AppConfig.setup do |config|
  config[:storage_method] = :yaml
  config[:path] = Rails.root.join('config/app_config.yaml')
end

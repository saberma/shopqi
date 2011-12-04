#ActionMailer::Base.smtp_settings = {
#  address: "smtp.163.com",
#  port: 25,
#  domain: "163.com",
#  user_name: "shopqi_test@163.com",
#  password: "666666",
#  authentication: :plain,
#  enable_starttls_auto: false
#}

ActionMailer::Base.sendmail_settings = {
  location: '/usr/sbin/sendmail'
}

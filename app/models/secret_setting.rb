# 放置保密类配置信息
class SecretSetting < Settingslogic
  source "#{Rails.root}/config/app_secret_config.yml"
  namespace Rails.env
  load!
end

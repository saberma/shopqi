class Setting < Settingslogic
  source "#{Rails.root}/config/app_config.yml"
  namespace Rails.env

  def self.theme_store_url
    url = "http://themes.#{Setting.domain.url}"
    url += ":#{Setting.domain.port}" unless Setting.domain.port == 80
    url
  end
end

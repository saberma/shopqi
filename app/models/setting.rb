class Setting < Settingslogic
  source "#{Rails.root}/config/app_config.yml"
  namespace Rails.env

  # TODO: 移至ShopDomain
  def self.domain_url # lvh.me:4000
    url = "#{Setting.domain.url}"
    url += ":#{Setting.domain.port}" unless Setting.domain.port == 80
    url
  end

  def self.store_url # http://lvh.me:4000
    "http://#{Setting.domain_url}"
  end

  def self.theme_store_url # http://themes.lvh.me:4000
    "http://themes.#{Setting.domain_url}"
  end
end

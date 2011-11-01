class Setting < Settingslogic
  source "#{Rails.root}/config/app_config.yml"
  namespace Rails.env

  begin 'shopqi.com'

    def self.host # shopqi.com
      Setting.domain.host
    end

  end

  begin '.myshopqi.com'

    def self.store_host # .myshopqi.com
      ".#{self.host}"
    end

  end

end

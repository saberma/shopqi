class Setting < Settingslogic
  source "#{Rails.root}/config/app_config.yml"
  namespace Rails.env

  begin '.shopqi.com'
    def self.host_with_port # shopqi.com:4000
      add_port_to(Setting.domain.host)
    end

    def self.url # http://shopqi.com:4000
      "http://#{Setting.host_with_port}"
    end

    def self.theme_store_url # http://themes.shopqi.com:4000
      "http://themes.#{Setting.host_with_port}"
    end
  end

  begin '.myshopqi.com'
    def self.store_host # .myshopqi.com
      ".#{Setting.domain.store_host}"
    end

    def self.store_host_with_port # .myshopqi.com:4000
      add_port_to(store_host)
    end
  end

  begin 'plans for shopqi'
    def self.plans(name)
      Setting.plans.__send__ name
    end
  end

  private
  def self.add_port_to(host)
    host += ":#{Setting.domain.port}" unless Setting.domain.port == 80
    host
  end
end

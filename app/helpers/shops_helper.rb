module ShopsHelper

  #用于获得当前请求商店的地址
  def show_shop_url
    "#{shop.primary_domain.url}#{request.port_string}"
  end

  begin '.shopqi.com'

    def host_with_port # shopqi.com:4000
      "#{Setting.host}#{request.port_string}"
    end

    def url_with_port # http://shopqi.com:4000
      "http://#{host_with_port}"
    end

    def theme_store_url_with_port # http://themes.shopqi.com:4000
      "http://themes.#{host_with_port}"
    end

    def wiki_url_with_port # http://wiki.shopqi.com:4000
      "http://wiki.#{host_with_port}"
    end

  end

  begin '.myshopqi.com'

    def store_host_with_port # .myshopqi.com:4000
      "#{Setting.store_host}#{request.port_string}"
    end

  end

  def is_home?
    params[:controller] == 'admin/home'
  end

end

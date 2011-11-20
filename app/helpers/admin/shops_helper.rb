module Admin::ShopsHelper

  #用于获得当前请求商店的地址
  def show_shop_url # http://shopqi.com:4000
    "#{shop.primary_domain.url}#{request.port_string}"
  end

  begin '.shopqi.com'

    def host_with_port # shopqi.com:4000
      "#{Setting.host}#{request.port_string}"
    end

    def url_with_port # http://shopqi.com:4000
      "#{url_protocol}#{host_with_port}"
    end

    def theme_store_url_with_port # http://themes.shopqi.com:4000
      "#{url_protocol}themes.#{host_with_port}"
    end

    def wiki_url_with_port # http://wiki.shopqi.com:4000
      "#{url_protocol}wiki.#{host_with_port}"
    end

    def checkout_url_with_port # http://checkout.shopqi.com:4000 #TODO: 要修改为https协议
      "#{url_protocol}checkout.#{host_with_port}"
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

  protected
  def url_protocol
    Rails.env == "production"  ? "https://" : "http://"
  end

  def url_with_protocol(url)
    if url == ""
      url
    elsif url =~ /^(http:\/\/|^https:\/\/)([a-z0-9\-])*$/
      "#{url}.#{host_with_port}"
    elsif url =~ /^http:\/\/|^https:\/\//
      url
    elsif url =~ /^([a-z0-9\-])*$/
      "#{url_protocol}#{url}.#{host_with_port}"
    else
      "#{url_protocol}#{url}"
    end
  end

end

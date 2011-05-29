module ShopHelper

  #用于获得当前请求商店的地址
  #如果，未存在对应的商店，则显示
  #官网链接
  def show_shop_url
    unless shop
      "#{request.protocol}#{request.domain}#{request.port_string}"
    else
      "#{request.protocol}#{shop.permanent_domain}.#{request.domain}#{request.port_string}"
    end
  end

end

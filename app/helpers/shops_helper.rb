module ShopsHelper

  #用于获得当前请求商店的地址
  def show_shop_url
    "http://#{shop.domains.primary.name}#{Setting.domain.port}"
  end

end

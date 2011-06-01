class ShopDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def id
    @shop.id
  end

  def name
    @shop.name
  end

  # UrlFilter调用
  def asset_path(asset)
    @shop.theme.asset_relative_path(asset)
  end

end

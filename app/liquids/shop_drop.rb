class ShopDrop < Liquid::Drop

  def initialize(shop, theme)
    @shop = shop
    @theme = theme
  end

  def id
    @shop.id
  end

  def name
    @shop.name
  end

  # UrlFilter调用
  def asset_path(asset)
    @theme.asset_relative_path(asset)
  end

end

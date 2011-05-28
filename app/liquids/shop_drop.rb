class ShopDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def id
    @shop.id
  end

end

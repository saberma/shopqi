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

end

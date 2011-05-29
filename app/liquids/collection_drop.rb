class CollectionDrop < Liquid::Drop

  def initialize(shop, collection = nil)
    @shop = shop
    @collection = collection
  end
  
  def frontpage
    self.class.new @shop.custom_collections.where(handle: :frontpage).first
  end

  def products
    @collection.products
  end

end


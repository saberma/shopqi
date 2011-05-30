class CollectionDrop < Liquid::Drop

  def initialize(shop, collection = nil)
    @shop = shop
    @collection = collection
  end
  
  def frontpage
    self.class.new @shop, @shop.custom_collections.where(handle: :frontpage).first
  end

  def products
    @collection.products.map do |product|
      ProductDrop.new product
    end
  end

end

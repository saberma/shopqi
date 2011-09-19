class CollectionsDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    CollectionDrop.new(@shop.custom_collections.where(published: true, handle: handle).first)  || CollectionDrop.new(@shop.smart_collections.where(published: true, handle: handle).first)
  end

  def all
    @collections ||= @shop.collections.map do |collection|
      CollectionDrop.new collection
    end
  end

end

class CollectionDrop < Liquid::Drop

  delegate :title, :handle, to: :@collection

  def initialize(collection)
    @collection = collection
  end

  def products #数组要缓存，以便paginate替换为当前页
    @products ||= @collection.products.map do |product|
      ProductDrop.new product
    end
  end

  def description
    @collection.body_html
  end

  def url
    "/collections/#{@collection.handle}"
  end

  #显示集合包含的所有商品的product_type
  def all_types
    self.products.map(&:type).uniq! if @collection.handle != 'types'
  end

  #显示集合包含的所有商品的品牌
  def all_vendors
  end

  #显示匹配当前集合，当前页面的商品总数
  def products_count
  end

end

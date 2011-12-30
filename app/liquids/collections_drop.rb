class CollectionsDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    collection = @shop.collection(handle) || @shop.custom_collections.new
    CollectionDrop.new(collection)
  end

  def all
    @shop.collections.map do |collection|
      CollectionDrop.new collection
    end
  end
  memoize :all

  def each(&block) # 对象支持直接迭代
    all.each(&block)
  end

end

class CollectionDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  delegate :title, :handle, to: :@collection

  def initialize(collection)
    @collection = collection
  end

  def products #数组要缓存，以便paginate替换为当前页(TODO: 此方法应与all_products区别，关联paginate)
    #注：不能用products.where,因为有地方是直接用collection.new来直接关联products,
    #而没有在数据库中存储对应的记录的
    @collection.products.map do |product|
      ProductDrop.new product if product.published #只显示product published的商品
    end.compact
  end
  memoize :products

  def description
    @collection.body_html
  end

  def url
    "/collections/#{@collection.handle}"
  end

  def all_types #显示集合包含的所有商品的product_type
    self.products.map(&:type).uniq if !['types','all','vendors'].include?(@collection.handle)
  end

  def all_vendors #显示集合包含的所有商品的品牌
    self.products.map(&:vendor).uniq if !['types','all','vendors'].include?(@collection.handle)
  end

  def products_count #显示匹配当前集合，当前页面的商品总数
    self.products.size
  end

  def all_products #所有商品
    @collection.products.map do |product|
      ProductDrop.new product if product.published #只显示product published的商品
    end.compact
  end

  def all_products_count #显示当前集合所含商品总数
    self.all_products.size
  end

  def all_tags #显示集合中所有商品的标签
    self.all_products.map(&:tags).flatten.map(&:name).uniq
  end

  def tags #显示集合中当前页面商品所包含的标签
    self.products.map(&:tags).flatten.map(&:name).uniq
  end

  def previous_product # 集合中的上一个商品
    product = @context['product']
    index = product && product_drops.keys.index(product.id)
    previous_id = index && !index.zero? && product_drops.keys[index-1]
    if previous_id
      previous_product = product_drops[previous_id]
      "#{self.url}#{previous_product.url}"
    end
  end

  def next_product # 集合中的下一个商品
    product = @context['product']
    index = product && product_drops.keys.index(product.id)
    next_id = index && product_drops.keys[index+1]
    if next_id
      next_product = product_drops[next_id]
      "#{self.url}#{next_product.url}"
    end
  end

  private
  def product_drops # {1 => ProductDrop.new(product)}
    Hash[ *self.products.map do |product_drop|
      [product_drop.id, product_drop]
    end.flatten ]
  end
  memoize :product_drops

end

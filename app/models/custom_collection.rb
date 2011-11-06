# encoding: utf-8
class CustomCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :collection_products, dependent: :destroy          , class_name: 'CustomCollectionProduct'
  has_many :products           , through: :collection_products, order: '"custom_collection_products"."position" asc' # 商店使用

  validates_presence_of :title

  before_create do
    set_default_order
  end

  before_save do
    Handle.make_valid(shop.custom_collections, self)
  end

  #默认排序
  def set_default_order
    self.products_order = KeyValues::Collection::Order.first.code
  end

  def ordered_products #排序后的商品(只在后台管理中显示，商店显示时直接使用position排序)
    order_text = "position asc"
    order_text = "products.#{self.products_order.sub '.', ' '}" if self.products_order != 'manual'
    collection_products.ordered(order_text)
  end

end

#集合关联的商品
class CustomCollectionProduct < ActiveRecord::Base
  belongs_to :custom_collection
  belongs_to :product

  def self.ordered(products_order = 'position asc')
    self.select("custom_collection_products.*").joins(:product).order(products_order) # issues#231
  end
end

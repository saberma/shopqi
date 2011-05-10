# encoding: utf-8
class CustomCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :products, class_name: 'CustomCollectionProduct', dependent: :destroy

  before_create do
    self.handle = 'handle'
    set_default_order
  end

  #默认排序
  def set_default_order
    self.products_order = KeyValues::Collection::Order.first.code
  end

  #排序后的商品
  def ordered_products
    products.ordered("products.#{self.products_order.sub '.', ' '}")
  end
end

#集合关联的商品
class CustomCollectionProduct < ActiveRecord::Base
  belongs_to :custom_collection
  belongs_to :product

  def self.ordered(products_order = 'position asc')
    joins(:product).order(products_order)
  end
end

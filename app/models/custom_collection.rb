# encoding: utf-8
class CustomCollection < ActiveRecord::Base
  belongs_to :shop
  has_many :collection_products, dependent: :destroy          , class_name: 'CustomCollectionProduct'
  has_many :products           , through: :collection_products

  validates_presence_of :title

  before_create do
    set_default_order
  end

  before_save do
    self.handle = Pinyin.t(self.title) if self.handle.blank?
    self.handle = Handle.make_valid(shop.custom_collections, self.handle)
  end

  #默认排序
  def set_default_order
    self.products_order = KeyValues::Collection::Order.first.code
  end

  #排序后的商品
  def ordered_products
    collection_products.ordered("products.#{self.products_order.sub '.', ' '}")
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

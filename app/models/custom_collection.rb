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
end

#集合关联的商品
class CustomCollectionProduct < ActiveRecord::Base
  belongs_to :custom_collection
  belongs_to :product

  default_scope :order => 'position asc'
end

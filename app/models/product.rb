# encoding: utf-8
class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :photos  , dependent: :destroy
  has_many :variants, dependent: :destroy, class_name: 'ProductVariant'

  accepts_nested_attributes_for :photos  , allow_destroy: true
  accepts_nested_attributes_for :variants, allow_destroy: true

  validates_presence_of :title, :product_type, :vendor
end

#商品款式
class ProductVariant < ActiveRecord::Base
  belongs_to :product
  validates_presence_of :price, :weight
end

# encoding: utf-8
class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :photos  , dependent: :destroy
  has_many :variants, dependent: :destroy, class_name: 'ProductVariant'
  has_many :options , dependent: :destroy, class_name: 'ProductOption'
  has_and_belongs_to_many :tags
  attr_accessor :tags_text

  accepts_nested_attributes_for :photos  , allow_destroy: true
  accepts_nested_attributes_for :variants, allow_destroy: true
  accepts_nested_attributes_for :options

  validates_presence_of :title, :product_type, :vendor

  after_save do
    tags_text.split(',').uniq.each do |tag_text|
      tag = shop.tags.where(name: tag_text).first
      tag = shop.tags.create name: tag_text unless tag
      self.tags << tag
    end
  end
end

#商品款式
class ProductVariant < ActiveRecord::Base
  belongs_to :product
  validates_presence_of :price, :weight
end

#商品选项
class ProductOption < ActiveRecord::Base
  belongs_to :product
  #辅助值，用于保存至商品款式中
  attr_accessor :value
end

# encoding: utf-8
class Shipping < ActiveRecord::Base
  belongs_to :shop
  has_many :weight_based_shipping_rates
  has_many :price_based_shipping_rates
end

class WeightBasedShippingRate < ActiveRecord::Base # 基于重量计算的运费
  belongs_to :shipping
  default_value_for :weight_low , 0.0
  default_value_for :weight_high, 25.0
  default_value_for :price, 10.0
  validates_presence_of :name

  def shipping_rate # 保存在order的配送方式
    "#{self.name}-#{self.price}"
  end
end

class PriceBasedShippingRate < ActiveRecord::Base # 基于价格计算的运费(适合珠宝手饰等贵重物品)
  belongs_to :shipping
  default_value_for :min_order_subtotal , 50.0
  default_value_for :price, 0.0
  validates_presence_of :name

  def shipping_rate # 保存在order的配送方式
    "#{self.name}-#{self.price}"
  end
end

# encoding: utf-8
class Shipping < ActiveRecord::Base
  belongs_to :shop
  has_many :weight_based_shipping_rates, dependent: :destroy, order: 'id asc'
  has_many :price_based_shipping_rates , dependent: :destroy, order: 'id asc'
  attr_accessible :code

  # 修改此模块内方法要记得重启服务
  module Extension # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html #Association extensions
    def shop
      @association.owner
    end

    # 根据订单的重量、价格、目的地获取快递费用
    # @code 目的地(如440305，指深圳)
    def rates(weight, price, code)
      #p "weight: #{weight}; price: #{price}, code: #{code}"
      shipping = shop.shippings.where(code: code).first # 区
      return shipping.match(weight, price) if shipping
      shipping = shop.shippings.where(code: District.city(code)).first # 市
      return shipping.match(weight, price) if shipping
      shipping = shop.shippings.where(code: District.province(code)).first # 省
      return shipping.match(weight, price) if shipping
      shipping = shop.shippings.where(code: District::CHINA).first # 全国
      return shipping.match(weight, price) if shipping
    end
  end

  def code_name # 区域
    return '全国' if self.code == District::CHINA
    District.get self.code, prepend_parent: true
  end

  def match(weight, price) # 找出符合快递记录
    self.weight_based_shipping_rates.where(:weight_low.lte => weight, :weight_high.gte => weight).all + self.price_based_shipping_rates.where(:min_order_subtotal.lte => price, :max_order_subtotal.gte => price).all + self.price_based_shipping_rates.where(:min_order_subtotal.lte => price, :max_order_subtotal => nil).all
  end
end

class WeightBasedShippingRate < ActiveRecord::Base # 基于重量计算的运费
  belongs_to :shipping
  default_value_for :weight_low , 0.0
  default_value_for :weight_high, 25.0
  default_value_for :price, 10.0
  attr_accessible :price, :weight_low, :weight_high, :name
  validates_presence_of :name

  def shipping_rate # 保存在order的配送方式
    "#{self.name}-#{self.price}"
  end
end

class PriceBasedShippingRate < ActiveRecord::Base # 基于价格计算的运费(适合珠宝手饰等贵重物品)
  belongs_to :shipping
  default_value_for :min_order_subtotal , 50.0
  default_value_for :price, 0.0
  attr_accessible :price, :min_order_subtotal, :max_order_subtotal, :name
  validates_presence_of :name

  def shipping_rate # 保存在order的配送方式
    "#{self.name}-#{self.price}"
  end
end

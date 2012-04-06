# encoding: utf-8
class Discount < ActiveRecord::Base
  belongs_to :shop

  before_save do
    self.code = self.code.blank? ? self.class.generate_code : self.code
    self.value ||= 5
  end

  def self.generate_code # 8位随机码
    o = [(0..9),('A'..'Z')].map{|i| i.to_a}.flatten
    (1..8).map{ o[rand(o.length)]  }.join
  end

  # 修改此模块内方法要记得重启服务
  module Extension # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html #Association extensions
    def shop
      @association.owner
    end

    # @options {code: '123', cart: cart, order: order}
    def apply(options)
      cart_or_order = options[:cart] || options[:order]
      result = {}
      discount = shop.discounts.where(code: options[:code]).first
      if discount
        if discount.usage_limit.nil? or (discount.usage_limit - discount.used_times > 0)
          amount = [discount.value, cart_or_order.total_price].min # 优惠金额比订单金额大时，取订单金额
          result = {code: discount.code, amount: amount}
        end
      end
      result
    end
  end
end

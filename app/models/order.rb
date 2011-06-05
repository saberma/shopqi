#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop
  has_one :billing_address , class_name: 'OrderBillingAddress'
  has_one :shipping_address, class_name: 'OrderShippingAddress'

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address
end

# 发单人信息
class OrderBillingAddress < ActiveRecord::Base
  belongs_to :order
end

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
end

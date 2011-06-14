#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  has_one :billing_address , dependent: :destroy, class_name: 'OrderBillingAddress'
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress'
  has_many :variants       , dependent: :destroy, class_name: 'OrderProductVariant'

  attr_protected :total_price #总金额只能通过商品价格计算而来，不能从页面传递

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates_presence_of :email, message: '此栏不能为空白'
  validates_presence_of :shipping_rate, :gateway, on: :update

  before_create do
    self.token = UUID.generate(:compact)
    self.number = shop.orders.size + 1
    self.order_number = self.number + 1000 # 1001比0001给顾客感觉更好
    self.name = shop.order_number_format.gsub /{{number}}/, self.order_number.to_s
  end

  before_save do
    self.total_price = self.variants.map(&:price).sum
  end

end

# 订单商品
class OrderProductVariant < ActiveRecord::Base
  belongs_to :order
  belongs_to :product_variant
  validates_presence_of :price, :quantity
end

# 发单人信息
class OrderBillingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  before_create do
    self.country = 'china'
  end
end

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  before_create do
    self.country = 'china'
  end
end

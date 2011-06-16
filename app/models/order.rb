#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  has_one :billing_address , dependent: :destroy, class_name: 'OrderBillingAddress'
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress'
  has_many :line_items     , dependent: :destroy, class_name: 'OrderLineItem'

  attr_protected :total_price #总金额只能通过商品价格计算而来，不能从页面传递

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates_presence_of :email, message: '此栏不能为空白'
  validates_presence_of :shipping_rate, :gateway, on: :update

  default_value_for :status, 'open'
  default_value_for :financial_status, 'abandoned'
  default_value_for :fulfillment_status, 'unshipped'

  before_create do
    self.token = UUID.generate(:compact)
    self.number = shop.orders.size + 1
    self.order_number = self.number + 1000 # 1001比0001给顾客感觉更好
    self.name = shop.order_number_format.gsub /{{number}}/, self.order_number.to_s
  end

  before_save do
    self.total_price = self.variants.map(&:price).sum
  end

  def status_name
    KeyValues::Order::Status.find_by_code(status).name
  end

  def financial_status_name
    KeyValues::Order::FinancialStatus.find_by_code(financial_status).name
  end

  def fulfillment_status_name
    KeyValues::Order::FulfillmentStatus.find_by_code(fulfillment_status).name
  end

end

# 订单商品
class OrderLineItem < ActiveRecord::Base
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

  def province_name
    District.get(self.province)
  end

  def city_name
    District.get(self.city)
  end

  def district_name
    District.get(self.district)
  end
end

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  before_create do
    self.country = 'china'
  end

  def province_name
    District.get(self.province)
  end

  def city_name
    District.get(self.city)
  end

  def district_name
    District.get(self.district)
  end
end

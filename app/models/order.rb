#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  has_one :billing_address , dependent: :destroy, class_name: 'OrderBillingAddress'
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress'
  has_many :line_items     , dependent: :destroy, class_name: 'OrderLineItem'
  has_many :transactions   , dependent: :destroy, class_name: 'OrderTransaction'
  has_many :fulfillments   , dependent: :destroy, class_name: 'OrderFulfillment'
  has_many :histories      , dependent: :destroy, class_name: 'OrderHistory', order: :id.desc

  attr_accessible :email, :shipping_rate, :gateway, :note, :billing_address_attributes, :shipping_address_attributes, :cancel_reason

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates_presence_of :email, message: '此栏不能为空白'
  #validates_presence_of :shipping_rate, :gateway, on: :update

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
    self.total_line_items_price = self.line_items.map(&:price).sum
    self.total_price = self.total_line_items_price
  end

  before_update do
    if status_changed?
      case self.status.to_sym
      when :closed
        self.closed_at = Time.now
        self.histories.create body: '订单被关闭'
      when :open
        self.closed_at = nil
        self.histories.create body: '订单重新打开'
      when :cancelled
        self.cancelled_at = Time.now
        self.histories.create body: '订单被取消.原因:#{cancel_reason_name}'
      end
    end
  end

  after_create do
    self.histories.create body: '创建订单'
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

  def cancel_reason_name
    KeyValues::Order::CancelReason.find_by_code(cancel_reason).name
  end

end

# 订单商品
class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product_variant
  has_and_belongs_to_many :fulfillments, class_name: 'OrderFulfillment'
  validates_presence_of :price, :quantity
  scope :unshipped, where(fulfilled: false)

  delegate :sku, to: :product_variant

  before_create do
    self.total_price = self.price * self.quantity
  end

  def fulfillment
    fulfillments.first
  end

  # 显示发货时间
  def fulfillment_created_at
    fulfillment.try(:created_at)
  end

  def title
    product_variant.product.title
  end

  def variant_title
    product_variant.options.join(' - ')
  end

  def sku
    product_variant.sku ? product_variant.sku : '没有SKU'
  end
end

# 支付记录
class OrderTransaction < ActiveRecord::Base
  belongs_to :order

  before_create do
    self.amount = order.total_price #非信用卡,手动接收款项
  end

  after_create do
    self.order.update_attribute :financial_status, :paid
    self.order.histories.create body: "我们已经成功接收款项"
  end
end

# 配送记录相关订单商品
class OrderFulfillment < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :order
  has_and_belongs_to_many :line_items, class_name: 'OrderLineItem'

  after_create do
    line_items.each do |line_item|
      line_item.update_attribute :fulfilled, true
    end
    fulfillment_status = (self.order.line_items.unshipped.size > 0) ? :partial : :fulfilled
    self.order.update_attribute :fulfillment_status, fulfillment_status
    self.order.histories.create body: "我们已经将#{line_items.size}个商品发货", url: order_fulfillment_path(self.order, self)
  end
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

# 订单历史
class OrderHistory < ActiveRecord::Base
  belongs_to :order
end

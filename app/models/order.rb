#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  belongs_to :customer     , counter_cache: true    #顾客信息
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress' #收货人信息
  has_many :line_items     , dependent: :destroy, class_name: 'OrderLineItem' #订单商品
  has_many :transactions   , dependent: :destroy, class_name: 'OrderTransaction' #支付记录
  has_many :fulfillments   , dependent: :destroy, class_name: 'OrderFulfillment', order: "updated_at desc " #配送记录
  has_many :histories      , dependent: :destroy, class_name: 'OrderHistory', order: :id.desc #订单历史
  belongs_to  :payment        , class_name: 'Payment' #支付方式

  attr_accessible :id, :email, :shipping_rate,  :note, :shipping_address_attributes, :cancel_reason, :total_weight

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
    self.total_line_items_price = self.line_items.map(&:total_price).sum
    self.total_price = self.total_line_items_price + self.tax_price unless self.total_price
  end

  def shipping_rate_price
    shipping_rate.gsub(/.+-/,'').to_f if shipping_rate
  end

  def order_tax_price
    shop.taxes_included? ? 0.0  : self.tax_price
  end

  #订单商品总重量
  #用于匹配相应的快递方式的价钱
  def total_weight
    line_items.map(&:product_variant).map(&:weight).sum
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
    if financial_status_changed? and financial_status.to_sym == :pending # 一旦进入此待支付状态则需要更新顾客消费总金额
      self.customer.increment! :total_spent, self.total_price
    end
  end

  after_create do
    self.histories.create body: '创建订单'
  end

  scope :today, where(:created_at.gt => Date.today.beginning_of_day)

  scope :yesterday, where(:created_at.gt => Date.yesterday.beginning_of_day).where(:created_at.lt => Date.today.beginning_of_day)

  scope :between, lambda{|d1,d2| where(:created_at.gte => d1, :created_at.lt => d2.tomorrow) }

  searchable do
    integer :shop_id, references: Shop
    text :name
    text :customer_name do
      customer.name
    end
    text :customer_email do
      customer.email
    end
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

  def title
    "订单 #{name}"
  end

  def pay!
    order.financial_status = 'paid'
    #TODO
    #支付记录
  end

  def send_email(mail_type,email_address = self.email)
    Resque.enqueue(ShopqiMailer, email_address ,self.id ,self.shop.emails.find_by_mail_type(mail_type).id )
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

  def total_price
    self.price * self.quantity
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

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  def country
    order.shop.countries.where(code: country_code).first
  end

  def country_name
    Carmen.country_name(country_code)
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

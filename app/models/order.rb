#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  belongs_to :customer     , counter_cache: true    #顾客信息
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress' #收货人信息
  has_many :line_items     , dependent: :destroy, class_name: 'OrderLineItem'   , order: :id.asc #订单商品
  has_many :transactions   , dependent: :destroy, class_name: 'OrderTransaction' #支付记录
  has_many :fulfillments   , dependent: :destroy, class_name: 'OrderFulfillment', order: :updated_at.desc #配送记录
  has_many :histories      , dependent: :destroy, class_name: 'OrderHistory'    , order: :id.desc #订单历史
  belongs_to  :payment     , class_name: 'Payment' #支付方式

  attr_accessible :id, :email, :shipping_rate, :note, :shipping_address_attributes, :cancel_reason, :total_weight, :payment_id

  accepts_nested_attributes_for :shipping_address

  validates_presence_of :email, :shipping_address, :shipping_rate, :payment_id, message: '此栏不能为空白'
  #validates :shipping_rate, inclusion: { in: %w()} # TODO: 配送记录必须存在

  default_value_for :status, 'open'
  default_value_for :financial_status, 'pending'
  default_value_for :fulfillment_status, 'unshipped'

  before_create do
    self.token ||= UUID.generate(:compact) # 普通情况下token与cart的token一致，方便订单提交后清空购物车
    self.number = shop.orders.size + 1
    self.order_number = self.number + 1000 # 1001比0001给顾客感觉更好
    self.name = shop.order_number_format.gsub /{{number}}/, self.order_number.to_s
  end

  before_save do
    self.total_line_items_price = self.line_items.map(&:total_price).sum
    self.total_price = self.total_line_items_price + self.tax_price unless self.total_price
  end

  def shipping_rate_price
    shipping_rate.gsub(/.+\s*-/,'').to_f if shipping_rate
  end

  def shipping_name
    shipping_rate.scan(/(.+?)\s*-/).flatten[0] if shipping_rate
  end

  def order_tax_price
    shop.taxes_included? ? 0.0  : self.tax_price
  end

  def gateway
    payment.name.blank? ? payment.payment_type.try(:name) : payment.name if payment
  end

  #订单商品总重量
  #用于匹配相应的快递方式的价钱
  def total_weight
    line_items.map(&:total_weight).sum
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
    if financial_status_changed? and financial_status_pending? # 一旦进入此待支付状态则需要更新顾客消费总金额
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

  begin 'financial_status'

    def financial_status_pending? # 待支付?
      self.financial_status.to_sym == :pending
    end

    def financial_status_paid? # 已支付?
      self.financial_status.to_sym == :paid
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

  def pay!(amount)
    self.transactions.create kind: :capture, amount: amount
    self.send_email_when_order_forward
  end

  def send_email(mail_type,email_address = self.email)
    Resque.enqueue(ShopqiMailer, email_address ,self.id ,mail_type, self.shop.id )
  end

  def send_email_when_order_forward
    #发送客户确认邮件
    send_email("order_confirm")
    #给网店管理者发送邮件
    shop.subscribes.map(&:email_address).each do |email_address|
      send_email("new_order_notify",email_address)
    end
  end

end

# 订单商品
class OrderLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :product_variant
  has_and_belongs_to_many :fulfillments, class_name: 'OrderFulfillment'
  validates_presence_of :price, :quantity
  scope :unshipped, where(fulfilled: false)

  before_create do
    self.init
  end

  def init # 保存款式冗余属性
    self.product = product_variant.product
    self.product_id = product.id
    self.title = product.title
    self.variant_title = product_variant.title
    self.name = product_variant.name
    self.vendor = product.vendor
    self.requires_shipping = product_variant.requires_shipping
    self.grams = (product_variant.weight * 1000).to_i
    self.sku = product_variant.sku
  end

  def total_price
    self.price * self.quantity
  end

  def total_weight
    self.grams * self.quantity
  end

  def fulfillment
    fulfillments.first
  end

  def fulfillment_created_at # 显示发货时间
    fulfillment.try(:created_at)
  end

  def product_deleted # 商品已经被删除?
    product.nil?
  end
end

# 支付记录
class OrderTransaction < ActiveRecord::Base
  belongs_to :order

  before_create do
    self.amount ||= order.total_price #非信用卡,手动接收款项
  end

  after_create do
    amount_sum = self.order.transactions.map(&:amount).sum
    self.order.update_attribute :financial_status, :paid if amount_sum >= self.order.total_price
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

  def province_name
    District.get(self.province)
  end

  def city_name
    District.get(self.city)
  end

  def district_name
    District.get(self.district)
  end

  def info # 获取地址详情
    "#{province_name}#{city_name}#{district_name}#{address1}#{address2}"
  end
end

# 订单历史
class OrderHistory < ActiveRecord::Base
  belongs_to :order
end

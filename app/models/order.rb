#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop         , counter_cache: true
  belongs_to :customer     , counter_cache: true    #顾客信息
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress' #收货人信息
  has_one :discount        , dependent: :destroy, class_name: 'OrderDiscount'   , order: :id.desc #订单优惠
  has_many :line_items     , dependent: :destroy, class_name: 'OrderLineItem'   , order: :id.asc #订单商品
  has_many :transactions   , dependent: :destroy, class_name: 'OrderTransaction' #支付记录
  has_many :fulfillments   , dependent: :destroy, class_name: 'OrderFulfillment', order: :updated_at.desc #配送记录
  has_many :histories      , dependent: :destroy, class_name: 'OrderHistory'    , order: :id.desc #订单历史
  belongs_to  :payment     , class_name: 'Payment' #支付方式

  attr_accessible :id, :email, :shipping_rate, :note, :shipping_address_attributes, :cancel_reason, :total_weight, :payment_id
  attr_accessor :discount_code

  accepts_nested_attributes_for :shipping_address

  validates_presence_of :email, message: '此栏不能为空白'
  validates_presence_of :shipping_address, :shipping_rate, message: '此栏不能为空白', if: "requires_shipping?"
  validates_presence_of :payment_id, message: '此栏不能为空白', unless: "total_price.zero?"
  #validates :shipping_rate, inclusion: { in: %w()} # TODO: 配送记录必须存在

  default_value_for :status, 'open'
  default_value_for :financial_status, 'pending'
  default_value_for :fulfillment_status, 'unshipped'

  before_validation do
    if self.total_price.nil? # 新增时才计算总金额
      self.total_price = self.subtotal_price = self.total_line_items_price = self.line_items.map(&:total_price).sum
      self.total_price += self.shipping_rate_price if shipping_rate
      unless self.discount_code.blank? # 优惠码
        discount_json = self.shop.discounts.apply code: self.discount_code, order: self
        unless discount_json[:code].blank?
          amount = discount_json[:amount]
          self.build_discount code: discount_json[:code], amount: amount
          self.subtotal_price -= amount
          self.total_price -= amount
        end
      end
      self.financial_status = :paid if self.total_price.zero? # 订单总金额为0，直接进入已支付状态
    end
  end

  before_create do
    self.token ||= UUID.generate(:compact) # 普通情况下token与cart的token一致，方便订单提交后清空购物车
    self.number = shop.orders.size + 1
    self.order_number = self.number + 1000 # 1001比0001给顾客感觉更好
    self.name = shop.order_number_format.gsub /{{number}}/, self.order_number.to_s
    self.line_items.each do |line_item| # 跟踪库存
      variant = line_item.product_variant
      variant.decrement! :inventory_quantity, line_item.quantity if variant.manage_inventory?
    end
  end

  after_create do
    self.histories.create body: '创建订单'
    send_email("order_confirm") #发送客户确认邮件
    shop.subscribes.map(&:email_address).each do |email_address| #给网店管理者发送邮件
      send_email("new_order_notify",email_address)
    end
  end

  def shipping_rate_price
    shipping_rate.gsub(/.+\s*-/,'').to_f if shipping_rate
  end

  def shipping_name
    shipping_rate.scan(/(.+?)\s*-/).flatten[0] if shipping_rate
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
        self.histories.create body: "订单被取消.原因:#{cancel_reason_name}"
      end
    end
    if financial_status_changed? and financial_status_pending? # 一旦进入此待支付状态则需要更新顾客消费总金额
      self.customer.increment! :total_spent, self.total_price
    end
  end

  scope :status_open, where(status: 'open')

  scope :today, lambda { where(:created_at.gt => Date.today.beginning_of_day) }

  scope :yesterday, lambda{ where(:created_at.gt => Date.yesterday.beginning_of_day).where(:created_at.lt => Date.today.beginning_of_day) }

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

    def financial_status_refunded? # 已退款?
      self.financial_status.to_sym == :refunded
    end

  end

  begin 'status'

    def status_name
      KeyValues::Order::Status.find_by_code(status).name
    end

    def cancelled?
      status.to_sym == :cancelled
    end

    # options[:email] 发送邮件给顾客
    # options[:amount] 退款给顾客的金额，为 0 表示不退款
    def cancel!(options = {}) # 取消订单
      self.class.transaction do
        self.status = :cancelled
        self.save
        self.line_items.each do |line_item| # 跟踪库存
          variant = line_item.product_variant
          variant.increment! :inventory_quantity, line_item.quantity if variant.manage_inventory?
        end
        self.refund! options[:amount]
        send_email('order_cancelled') if options[:email]
      end
    end

    def refund!(amount = nil)
      amount = self.total_price if amount.blank?
      self.transactions.create!(kind: :refund, status: :pending, amount: amount, batch_no: Gateway::Alipay::Refund.generate_batch_no) if !amount.zero?
    end

    def refundable? # 支持退款
      self.financial_status_paid? and self.payment and self.payment.refundable?
    end

  end

  def financial_status_name
    KeyValues::Order::FinancialStatus.find_by_code(financial_status).name
  end

  begin 'fulfillment'

    def fulfillment_status_name
      KeyValues::Order::FulfillmentStatus.find_by_code(fulfillment_status).name
    end

    def fulfilled?
      fulfillment_status.to_sym == :fulfilled
    end

  end

  def cancel_reason_name
    KeyValues::Order::CancelReason.find_by_code(cancel_reason).name
  end

  def title
    "订单 #{name}"
  end

  def pay!(amount, trade_no = nil)
    self.trade_no = trade_no
    self.save
    self.transactions.create kind: :capture, amount: amount
  end

  def requires_shipping?
    #self.line_items.any?(&:requires_shipping) # line item 保存前，requires_shipping 还没有初始化
    self.line_items.map(&:product_variant).any?(&:requires_shipping)
  end

  def other_orders
    customer.orders.status_open.where("id != ?", self.id).as_json(only: [:id, :name, :created_at])
  end

  def send_email(mail_type, email_address = self.email)
    Resque.enqueue(ShopqiMailer, mail_type, email_address, self.id)
  end

  begin 'redis'

    def latest_tracking_company_key # 用于根据快递方式的不同取不同的物流公司
      "latest_tracking_company_#{self.shipping_name}"
    end

    def latest_tracking_number_key # 用于根据快递方式的不同取不同的运单号
      "latest_tracking_number_#{self.shipping_name}"
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
  attr_accessible :product_variant, :price, :quantity

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
  attr_accessible :kind, :amount, :status, :batch_no

  scope :pending_refund, where(kind: 'refund', status: 'pending')

  before_create do
    self.amount ||= order.total_price #非信用卡,手动接收款项
  end

  after_create do
    self.capture if capture?
  end

  before_update do
    self.refund if refund?
  end

  def capture
    amount_sum = self.order.transactions.map(&:amount).sum
    if amount_sum >= self.order.total_price
      self.order.financial_status = :paid
      self.order.save
    end
    self.order.histories.create body: "我们已经成功接收款项"
    Resque.enqueue(ShopqiMailer::Paid, self.id)
  end

  def refund
    if status_changed? and status.to_sym == :success # 退款成功
      self.order.financial_status = :refunded
      self.order.save
      self.order.histories.create body: "我们已经将款项退回给顾客"
    end
  end

  def capture?
    self.kind.to_sym == :capture
  end

  def refund?
    self.kind.to_sym == :refund
  end
end

# 配送记录相关订单商品
class OrderFulfillment < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :order
  has_and_belongs_to_many :line_items, class_name: 'OrderLineItem'
  attr_accessible :tracking_number, :tracking_company, :notify_customer, :line_item_ids
  attr_accessor :notify_customer # 是否发邮件通知顾客

  after_create do
    line_items.each do |line_item|
      line_item.fulfilled = true
      line_item.save
    end
    fulfillment_status = (self.order.line_items.unshipped.size > 0) ? :partial : :fulfilled
    self.order.fulfillment_status = fulfillment_status
    self.order.save
    self.order.histories.create body: "我们已经将#{line_items.size}个商品发货", url: order_fulfillment_path(self.order, self)
    Resque.enqueue(ShopqiMailer::Ship, 'ship_confirm', self.id) if self.notify_customer == 'true' #当选中通知顾客时，发送邮件(不管有没有写运货单号)
  end

  after_update do
    Resque.enqueue(ShopqiMailer::Ship, 'ship_update', self.id) if self.notify_customer == 'true' and self.changed?
  end

  after_save do
    unless self.tracking_number.blank?
      number = self.tracking_number[0..-5] # 去掉后四位
      order.shop.redis self.order.latest_tracking_company_key, self.tracking_company
      order.shop.redis self.order.latest_tracking_number_key, number unless number.blank?
    end
    Resque.enqueue(AlipaySendGoods, self.id) if order.payment and order.payment.escrow? and !self.tracking_number.blank? # 在线交易且为支付宝担保交易
  end
end

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'
  attr_accessible :name, :company, :province, :city, :district, :address1, :address2, :zip, :phone

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

  def full_info # 全地址
    "#{info}，#{company}，#{zip}，#{name}，#{phone}"
  end
end

# 订单历史
class OrderHistory < ActiveRecord::Base
  belongs_to :order
  attr_accessible :body, :url
end

class OrderDiscount < ActiveRecord::Base # 订单优惠
  belongs_to :order
  attr_accessible :code, :amount

  after_create do
    order.shop.discounts.decrement self.code
  end
end

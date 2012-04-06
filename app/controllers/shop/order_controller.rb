#encoding: utf-8
class Shop::OrderController < Shop::AppController
  include Admin::ShopsHelper
  PAYMENT_METHODS = [:notify, :done, :tenpay_notify, :tenpay_done]
  skip_before_filter :password_protected       , only: PAYMENT_METHODS
  skip_before_filter :must_has_theme           , only: PAYMENT_METHODS
  skip_before_filter :check_shop_avaliable     , only: PAYMENT_METHODS
  skip_before_filter :check_shop_access_enabled, only: PAYMENT_METHODS

  layout 'shop/checkout'

  expose(:shop) { Shop.at(request.host) }

  expose(:orders) { shop.orders }

  expose(:order) do
    if params[:token]
      o = orders.where(token: params[:token]).first
      o.update_attributes(params[:order]) if params[:order]
      o
    else
      o = orders.build(params[:order])
      o.token = cart.token # 普通情况下token与cart的token一致，方便订单提交后清空购物车
      o
    end
  end

  expose(:cart) { shop.carts.where(token: params[:cart_token]).first }

  before_filter only: :new do
    verify_customer!(cart)
  end

  expose(:cart_line_items) do
    cart.line_items
  end

  expose(:cart_total_weight) do
    cart.total_weight
  end

  expose(:cart_total_price) do
    cart.total_price
  end

  expose(:order_line_items) do
    order.line_items.inject({}) do |result, order_product_variant|
      result[order_product_variant.product_variant] = order_product_variant.quantity
      result
    end
  end

  expose(:order_total_price) do
    order.total_price
  end

  def new # 显示订单表单
    if cart_line_items.empty?
      render(action: 'error', layout: false) and return
    end
    @exist_discount = !shop.discounts.size.zero?
    order.build_shipping_address if order.shipping_address.nil?
  end

  def create # 提交订单
    if cart_line_items.empty?
      render json: {error: 'unavailable_product'} and return
    end

    order.discount_code = session['discount_code'] # 优惠码
    order.build_shipping_address(order.shipping_address.attributes)
    cart_line_items.each_pair do |variant, quantity|
      order.line_items.build product_variant: variant, price: variant.price, quantity: quantity
    end

    data = {}
    if order.save
      session['discount_code'] = nil
      shop.carts.where(token: order.token).first.try(:destroy) # 删除购物车实体
      order.send_email_when_order_forward if order.payment.name #发送邮件,非在线支付方式。在线支付方式在付款之后发送邮件
      data = {success: true, url: forward_order_path(params[:cart_token])}
    end
    render json: data
  end

  def forward
    render file: 'public/404.html',layout: false, status: 404 unless order
  end

  def shipping_rates # 获取快递记录
    total_weight = cart_total_weight / 1000.0 # 订单的total_weight以克为单位
    render json: shop.shippings.rates(total_weight, cart_total_price, params[:code]).as_json(root: false)
  end

  begin 'from pay gateway'

    begin '支付宝'

      def notify # 此action只供支付网关(支付宝)服务器的外部通知接口使用，通知我们订单支付状态(notify_url)
        notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
        @order = shop.orders.find_by_token(notification.out_trade_no)
        if @order and notification.acknowledge(@order.payment.key) and valid?(notification, @order.payment.account)
          @order.pay!(notification.total_fee) if notification.complete? and @order.financial_status_pending? # 要支持重复请求
          render text: "success"
        else
          render text: "fail"
        end
      end

      def done # 支付后从浏览器前台直接返回(return_url)
        pay_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
        @order = shop.orders.find_by_token(pay_return.order)
        @_resources = { shop: @order.shop } # checkout.haml中expose的shop
        if @order
          @order.pay!(pay_return.amount) if @order.financial_status_pending? # 要支持重复请求
        else
          raise pay_return.message
        end
      end

    end

    begin '财付通'

      def tenpay_notify # 此action只供支付网关(财付通)服务器的外部通知接口使用，通知我们订单支付状态(return_url)
        query_string = request.raw_post.blank? ? request.query_string : request.raw_post # 支持get和post方式
        notification = ActiveMerchant::Billing::Integrations::Tenpay::Return.new(query_string)
        @order = shop.orders.find_by_token(notification.order)
        if @order and notification.success?(@order.payment.key, @order.payment.account)
          @_resources = { shop: @order.shop } # checkout.haml中expose的shop
          @order.pay!(notification.total_fee) if @order.financial_status_pending? # 要支持重复请求
          render
        else
          render text: "fail"
        end
      end

      def tenpay_done # 支付后从浏览器前台直接返回(show_url)
        @order = shop.orders.find_by_token(params[:token])
        @_resources = { shop: @order.shop } # checkout.haml中expose的shop
        render action: :done
      end

    end

  end

  def apply_discount
    result = shop.discounts.apply code: params[:code], cart: cart
    session['discount_code'] = result[:code]
    render json: result
  end

  def get_address
    customer = cart.customer
    address = customer.addresses.where(id: params[:address_id]).first
    render json: address
  end

  protected

  def verify_customer!(cart)
    if cart.shop.customer_accounts_required? and !cart.customer
      redirect_to new_customer_session_url(checkout_url: "/carts/#{cart.token}")
    end
  end

  def valid?(notification, account) # 注意:支付宝的notify_id只在一分钟内才有效
    url = "https://www.alipay.com/cooperate/gateway.do?service=notify_verify"
    result = HTTParty.get(url, query: {partner: account, notify_id: notification.notify_id}).body
    result == 'true'
  end

end

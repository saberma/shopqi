#encoding: utf-8
class Shop::OrderController < Shop::AppController
  include Admin::ShopsHelper
  skip_before_filter :password_protected       , only: [:notify, :done, :tenpay_notify, :tenpay_done]
  skip_before_filter :must_has_theme           , only: [:notify, :done, :tenpay_notify, :tenpay_done]
  skip_before_filter :check_shop_avaliable     , only: [:notify, :done, :tenpay_notify, :tenpay_done]
  skip_before_filter :check_shop_access_enabled, only: [:notify, :done, :tenpay_notify, :tenpay_done]

  layout 'shop/checkout'

  expose(:shop) { Shop.find(params[:shop_id]) }

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

  before_filter only: :address do
    verify_customer!(cart)
  end

  expose(:cart_line_items) do
    JSON(cart.cart_hash).inject({}) do |result, (variant_id, quantity)|
      begin
        variant = shop.variants.find(variant_id)
        result[variant] = quantity
      rescue ActiveRecord::RecordNotFound # 款式已经被删除
      end
      result
    end
  end

  expose(:cart_total_price) do
    cart_line_items.map do |item|
      variant = item.first
      quantity = item.second
      quantity * variant.price
    end.sum
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

  expose(:countries){
    shop.countries
  }

  expose(:country){
    order.shipping_address.country
  }

  expose(:shipping_rates) do
    total_weight = order.total_weight / 1000.0 # 订单的total_weight以克为单位
    country.weight_based_shipping_rates.where(:weight_low.lte => total_weight,:weight_high.gte => total_weight ).all + country.price_based_shipping_rates.where(:min_order_subtotal.lte => order.total_line_items_price,:max_order_subtotal.gte => order.total_line_items_price ).all
  end

  # 订单提交Step1
  def address
    if cart.cart_hash.blank?
      render(action: 'error', layout: false) and return
    end
    order.build_shipping_address if order.shipping_address.nil?
  end

  # 提交订单: 填写完收货地址等就可以创建订单了
  def create
    address #初始化shipping_address
    order.build_shipping_address(order.shipping_address.attributes)
    JSON(cart.cart_hash).each_pair do |variant_id, quantity| #保存已购买商品
      begin
        variant = shop.variants.find(variant_id)
        order.line_items.build product_variant: variant, price: variant.price, quantity: quantity
      rescue ActiveRecord::RecordNotFound # 款式已被删除
      end
    end

    #税率
    order.tax_price = shop.taxes_included  ? 0.0 : cart_total_price * shop.countries.find_by_code(order.shipping_address.country_code).tax_percentage/100

    if order.save
      redirect_to pay_order_path(shop_id: shop.id, token: order.token)
    else
      render action: :address
    end
  end

  # 发货方式、付款方式Step2
  def pay
    order.payment ||= shop.payments.first
  end

  def forward
    render file: 'public/404.html',layout: false, status: 404 unless order
  end

  # 支付
  def commit
    data = {}
    include_shipping_rate = shipping_rates.map(&:shipping_rate).include? params[:order][:shipping_rate]
    if !include_shipping_rate || !params[:order][:payment_id]
      data = data.merge({error: 'shipping_rate', shipping_rate: params[:shipping_rate] }) if !include_shipping_rate
      data = data.merge({payment_error: true}) if !params[:order][:payment_id]
    else
      #若是已提交过的订单，则不做任何操作
      if order.payment.nil?
        params[:buyer_accepts_marketing] == 'true' ? order.customer.accepts_marketing = true : order.customer.accepts_marketing = false
        order.customer.save
        order.financial_status = 'pending'
        order.payment = shop.payments.find(params[:order][:payment_id])
        order.save
        shop.carts.where(token: order.token).first.try(:destroy) # 删除购物车实体
        order.send_email_when_order_forward if order.payment.name #发送邮件,非在线支付方式。在线支付方式在付款之后发送邮件
      end
      data = {success: true, url: forward_order_path(params[:shop_id],params[:token])}
    end
    render json: data
  end

  begin 'from pay gateway'

    begin '支付宝'

      def notify # 此action只供支付网关(支付宝)服务器的外部通知接口使用，通知我们订单支付状态(notify_url)
        notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
        @order = Order.find_by_token(notification.out_trade_no)
        if @order and notification.acknowledge(@order.payment.key) and valid?(notification, @order.payment.partner)
          @order.pay!(notification.total_fee) if notification.complete? and @order.financial_status_pending? # 要支持重复请求
          render text: "success"
        else
          render text: "fail"
        end
      end

      def done # 支付后从浏览器前台直接返回(return_url)
        pay_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
        @order = Order.find_by_token(pay_return.order)
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
        notification = ActiveMerchant::Billing::Integrations::Tenpay::Return.new(request.raw_post)
        @order = Order.find_by_token(notification.order)
        if @order and notification.success?(@order.payment.key, @order.payment.partner)
          @order.pay!(notification.total_fee) if @order.financial_status_pending? # 要支持重复请求
          render
        else
          render text: "fail"
        end
      end

      def tenpay_done # 支付后从浏览器前台直接返回(show_url)
        @order = Order.find_by_token(params[:token])
        @_resources = { shop: @order.shop } # checkout.haml中expose的shop
        render action: :done
      end

    end

  end

  def update_total_price
    #处理更新快递方式
    if !shipping_rates.map(&:shipping_rate).include? params[:shipping_rate]
      data = {error: 'shipping_rate', shipping_rate: params[:shipping_rate] }
    else
      order.shipping_rate = params[:shipping_rate]
      order.total_price = order.total_line_items_price + params[:shipping_rate].gsub(/.+-/,'').to_f + order.order_tax_price
      order.save
      data = {total_price: order.total_price, shipping_rate_price: order.shipping_rate_price}
    end
    render json: data
  end

  def update_tax_price
    country = shop.countries.find_by_code(params[:country_code])
    order_tax_price = shop.taxes_included  ? 0.0 : cart_total_price * country.tax_percentage/100
    total_price = cart_total_price + order_tax_price
    data = {total_price: total_price, order_tax_price: order_tax_price}
    render json: data
  end

  def get_address
    customer = cart.customer
    address = customer.addresses.where(id: params[:address_id]).first
    render json: address
  end

  protected

  def verify_customer!(cart)
    if cart.shop.customer_accounts_required? and !cart.customer
      redirect_to new_customer_session_url(checkout_url: "#{checkout_url_with_port}/carts/#{cart.shop_id}/#{cart.token}", host: "#{cart.shop.primary_domain.host}#{request.port_string}" )
    end
  end

  def valid?(notification, partner) # 注意:支付宝的notify_id只在一分钟内才有效
    url = "https://www.alipay.com/cooperate/gateway.do?service=notify_verify"
    result = HTTParty.get(url, query: {partner: partner, notify_id: notification.notify_id}).body
    result == 'true'
  end

end

#encoding: utf-8
class Shop::OrderController < Shop::AppController
  layout 'shop/checkout'

  expose(:shop) { Shop.find(params[:shop_id]) }

  expose(:orders) { shop.orders }

  expose(:order) do
    if params[:token]
      o = orders.where(token: params[:token]).first
      o.update_attributes(params[:order]) if params[:order]
      o
    else
      orders.build(params[:order])
    end
  end

  expose(:cart) { shop.carts.where(token: params[:cart_token]).first }

  before_filter { verify_customer!(cart) }

  expose(:cart_line_items) do
    JSON(cart.cart_hash).inject({}) do |result, (variant_id, quantity)|
      variant = shop.variants.find(variant_id)
      result[variant] = quantity
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
    country.weight_based_shipping_rates.where(:weight_low.lte => order.total_weight,:weight_high.gte => order.total_weight ).all + country.price_based_shipping_rates.where(:min_order_subtotal.lte => order.total_line_items_price,:max_order_subtotal.gte => order.total_line_items_price ).all
  end

  # 订单提交Step1
  def address
    if cart.cart_hash.blank?
      render(action: 'error', layout: false) and return
    end
    order.build_billing_address if order.billing_address.nil?
    order.build_shipping_address if order.shipping_address.nil?
  end

  # 提交订单: 填写完收货地址等就可以创建订单了
  def create
    address #初始化billing_address,shipping_address
    order.build_shipping_address(order.billing_address.attributes) if params[:billing_is_shipping]
    JSON(cart.cart_hash).each_pair do |variant_id, quantity| #保存已购买商品
      variant = shop.variants.find(variant_id)
      order.line_items.build product_variant: variant, price: variant.price, quantity: quantity
    end

    #增加默认的付款方式为支付宝
    order.payment = shop.payments.where(payment_type_id: KeyValues::PaymentType.first.id).first
    #税率
    order.tax_price = shop.taxes_included  ? 0.0 : cart_total_price * shop.countries.find_by_code(order.billing_address.country_code).tax_percentage/100

    if order.save
      redirect_to pay_order_path(shop_id: shop.id, token: order.token)
    else
      render action: :address
    end
  end

  # 发货方式、付款方式Step2
  def pay
  end

  def forward
  end

  # 支付
  def commit
    data = {}
    include_shipping_rate = shipping_rates.map{|s|"#{s.name}-#{s.price}"}.include? params[:order][:shipping_rate]
    if !include_shipping_rate || !params[:order][:payment_id]
      data = data.merge({error: 'shipping_rate', shipping_rate: params[:shipping_rate] }) if !include_shipping_rate
      data = data.merge({payment_error: true}) if !params[:order][:payment_id]
    else
      order.financial_status = 'pending'
      order.payment = shop.payments.find(params[:order][:payment_id])
      order.save
      data = {success: true, url: forward_order_path(params[:shop_id],params[:token])}
    end
    render json: data
  end

  def notify
    notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
    if notification.acknowledge && valid?(notification)
      @order = Order.find_by_token(notification.out_trade_no)
      @order.pay! if notification.status == "TRADE_FINISHED"
      render :text => "success"
    else
      render :text => "fail"
    end
  end

  def update_total_price
    #处理更新快递方式
    if !shipping_rates.map{|s|"#{s.name}-#{s.price}"}.include? params[:shipping_rate]
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
      redirect_to new_customer_session_url(checkout_url: "#{request.protocol}checkout.#{request.domain}#{request.port_string}/carts/#{cart.shop_id}/#{cart.token}", host: "#{cart.shop.primary_domain.host}#{request.port_string}" )
    end
  end

  private
  def valid?(notification)
    url = "http://notify.alipay.com/trade/notify_query.do"
    result = HTTParty.get(url, :query => {:partner => ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT, :notify_id => notification.notify_id}).body
    result == 'true'
  end

end

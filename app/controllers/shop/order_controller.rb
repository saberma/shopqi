#encoding: utf-8
class Shop::OrderController < Shop::ApplicationController
  layout 'shop/checkout'

  expose(:shop) { Shop.find(params[:shop_id]) }

  expose(:orders) { shop.orders }

  expose(:order) do
    if params[:uuid]
      o = orders.where(uuid: params[:uuid]).first
      o.update_attributes(params[:order]) if params[:order]
      o
    else
      orders.build(params[:order])
    end
  end

  expose(:cart) { shop.carts.where(uuid: params[:cart_uuid]).first }

  expose(:cart_variant_items) do
    JSON(cart.cart_hash).inject({}) do |result, (variant_id, quantity)|
      variant = shop.variants.find(variant_id)
      result[variant] = quantity
      result
    end
  end

  expose(:cart_total_price) do
    cart_variant_items.map do |item|
      variant = item.first
      quantity = item.second
      quantity * variant.price
    end.sum
  end

  expose(:order_variant_items) do
    order.variants.inject({}) do |result, order_product_variant|
      result[order_product_variant.product_variant] = order_product_variant.quantity
      result
    end
  end

  expose(:order_total_price) do
    order.variants.map(&:price).sum
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
      order.variants.build product_variant: variant, price: variant.price, quantity: quantity
    end
    if order.save
      redirect_to pay_order_path(order, shop_id: shop.id)
    else
      render action: :address
    end
  end

  # 发货方式、付款方式Step2
  def pay
  end

  # 支付
  def commit
    order.save
  end

end

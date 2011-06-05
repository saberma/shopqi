class Shop::OrderController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.find(params[:shop_id]) }

  expose(:orders) { shop.orders }

  expose(:order)

  expose(:variant_items) do
    cookie_cart_hash.inject({}) do |result, (variant_id, quantity)|
      variant = shop.variants.find(variant_id)
      result[variant] = quantity
      result
    end
  end

  expose(:total_price) do
    variant_items.map do |item|
      variant = item.first
      quantity = item.second
      quantity * variant.price
    end.sum
  end

  # 订单提交
  def new
    order.build_billing_address if order.billing_address.nil?
  end

  def create
  end
end

class Shop::OrderController < Shop::ApplicationController
  layout 'shop/checkout'

  prepend_before_filter :check_products!

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

  # 订单提交Step1
  def address
    session[:order_params] ||= {}
    session[:order_step] = order.steps.first
    order.build_billing_address if order.billing_address.nil?
    order.build_shipping_address if order.shipping_address.nil?
  end

  # 发货方式、付款方式Step2
  def pay
  end

  def create
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @_resources ||= {}
    @_resources[:order] = orders.build(session[:order_params]) #reset decent_exposure object
    order.build_shipping_address(order.billing_address.attributes) if params[:billing_is_shipping]
    order.current_step = session[:order_step]
    if order.valid?
      if order.last_step?
        order.save if order.all_valid?
      else
        order.next_step
      end
      session[:order_step] = order.current_step
    end
    if order.new_record?
      render action: order.current_step
    else
      session[:order_step] = session[:order_params] = nil
      redirect_to commit_order_path
    end
  end

  def check_products!
    if cookie_cart_hash.empty?
      render(action: 'error', layout: false) and return
    end
  end
end

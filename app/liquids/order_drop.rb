#encoding: utf-8
#订单关联的liquid属性
class OrderDrop < Liquid::Drop

  def initialize(order)
    @order = order
  end

  delegate :id, :name, :order_number,:gateway, :shipping_rate,:shipping_name, :shipping_rate_price, :payment, :total_price, :total_line_items_price,:cancelled_at, :created_at, to: :@order

  def date
    @order.created_at
  end

  def shipping_method
    ShippingMethodDrop.new @order
  end

  #支付细节
  def payment_details
  end

  def requires_shipping
    !@order.line_items.blank?
  end

  #税钱
  def tax_price
  end

  #各种税
  def tax_lines
  end

  #提交订单的顾客
  def customer
    CustomerDrop.new @order.customer
  end

  def shop_name
    @order.shop.name
  end


  def line_items
    @order.line_items.map do |line_item|
      OrderLineItemDrop.new(line_item)
    end
  end

  def shipping_address
    AddressDrop.new @order.shipping_address
  end

  #order关联的fulfillments按照更新时间排序，并且需为
  #降序排列,下面方法获取的fulfillment就是最后更新的那个
  def fulfillment
    OrderFulfillmentDrop.new(@order.fulfillments.first)  if  @order.fulfillments.first
  end

  def unfulfilled_line_items
  end

  #订单取消原因
  def cancel_reason
    KeyValues::Order::CancelReason.hash[@order.cancel_reason]
  end

  #如果订单已被取消，则返回true
  def cancelled
    @order.cancelled_at?
  end

  def financial_status
    @order.financial_status_name
  end

  def fulfillment_status
    @order.fulfillment_status_name
  end

  def customer_url
    "/account/orders/#{@order.token}"
  end

  def subtotal_price
    @order.total_line_items_price
  end

end

class OrderLineItemDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(order_line_item)
    @order_line_item = order_line_item
  end

  delegate :id, :title, :line_price, :price, :quantity, :sku, :grams, :requires_shipping, :vendor, to: :@order_line_item

  def variant
    ProductVariantDrop.new(@order_line_item.product_variant)
  end
  memoize :variant

  def product
    ProductDrop.new(@order_line_item.product)
  end
  memoize :product

  def line_price
    quantity * price
  end
  memoize :line_price

end

#配送记录
class OrderFulfillmentDrop < Liquid::Drop
  def initialize(fulfillment)
    @fulfillment = fulfillment
  end
  delegate :tracking_company, :tracking_number,:created_at,:updated_at, to: :@fulfillment

  def line_items
    @fulfillment.line_items.map do |line_item|
      OrderLineItemDrop.new(line_item)
    end
  end

end

class ShippingMethodDrop < Liquid::Drop
  def initialize(order)
    @order = order
  end

  def title
    @order.shipping_name
  end

  def price
    @order.shipping_rate_price
  end
end


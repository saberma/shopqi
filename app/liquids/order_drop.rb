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

  def shipping_methods
    [ShippingMethodDrop.new(@order)]
  end

  #支付细节
  def payment_details
  end

  def requires_shipping
    @order.requires_shipping?
  end

  def tax_price #税钱
  end

  def tax_lines #各种税
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

  def unfulfilled_line_items
  end

  def cancel_reason #订单取消原因
    KeyValues::Order::CancelReason.hash[@order.cancel_reason]
  end

  def cancelled #如果订单已被取消，则返回true
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
    @order.subtotal_price
  end

  def pay_url # #417
    "#{@order.shop.primary_domain.url}/orders/#{@order.token}"
  end

end

class OrderLineItemDrop < Liquid::Drop

  def initialize(order_line_item)
    @order_line_item = order_line_item
  end

  delegate :id, :line_price, :price, :quantity, :sku, :grams, :requires_shipping, :vendor, to: :@order_line_item

  def title
    @order_line_item.name
  end

  def variant
    @variant ||= ProductVariantDrop.new(@order_line_item.product_variant)
  end

  def product
    @product ||= ProductDrop.new(@order_line_item.product)
  end

  def line_price
    quantity * price
  end

  def fulfillment
    @fulfillment ||= OrderFulfillmentDrop.new(@order_line_item.fulfillments.first) if @order_line_item.fulfillments.first
  end

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

  def tracking_url
    KeyValues::Order::TrackingCompany.url(self.tracking_company)
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


#encoding: utf-8
#订单关联的liquid属性
class OrderDrop < Liquid::Drop

  def initialize(order)
    @order = order
  end

  delegate :id, :name, :order_number, :shipping_rate, :payment, :total_price, :total_line_items_price,:cancelled_at, to: :@order

  def date
    @order.created_at
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
    @order.line_items.map{|v| LineItemDrop.new(v.product_variant, v.quantity) }
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

end

#配送记录
class OrderFulfillmentDrop < Liquid::Drop
  def initialize(fulfillment)
    @fulfillment = fulfillment
  end
  delegate :tracking_company, :tracking_number,:created_at,:updated_at, to: :@fulfillment

  def line_items
    @fulfillment.line_items.map{|v| LineItemDrop.new(v.product_variant, v.quantity) }
  end

end


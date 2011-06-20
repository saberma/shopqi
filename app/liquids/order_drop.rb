#encoding: utf-8
#订单关联的liquid属性
class OrderDrop < Liquid::Drop

  def initialize(order)
    @order = order
  end

  def id
    @order.id
  end

  def order_name
    @order.name
  end

  def date
    @order.created_at
  end

  def order_number
    @order.order_number
  end

  def shipping_rate
    @order.shipping_rate
  end

  def billing_address
    @order.billing_address
  end

  #支付细节
  def payment_details
  end

  #税钱
  def tax_price
  end

  #各种税
  def tax_lines
  end

  #提交订单的顾客
  def customer
  end

  def order_name
  end

  def shop_name
    @order.shop.name
  end

  def gateway
    @order.gateway
  end

  def total_price
    @order.total_price
  end

  def line_items
    @order.line_items.map{|v| LineItemDrop.new(v.product_variant, v.quantity) }
  end

  def billing_address
    AddressDrop.new @order.billing_address
  end

  def shipping_address
    AddressDrop.new @order.shipping_address
  end

end


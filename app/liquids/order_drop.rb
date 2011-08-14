#encoding: utf-8
#订单关联的liquid属性
class OrderDrop < Liquid::Drop

  def initialize(order)
    @order = order
  end

  delegate :id, :name, :order_number, :shipping_rate, :payment, :total_price, :total_line_items_price, to: :@order

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
  end

  def shop_name
    @order.shop.name
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

  def fulfillment
  end

  def unfulfilled_line_items
  end
end


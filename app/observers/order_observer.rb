# encoding: utf-8
class OrderObserver < ActiveRecord::Observer

  def before_save(order)
    # 保存顾客信息
    shop = order.shop
    customer = shop.customers.where(email: order.email).first
    unless customer
      customer = shop.customers.create email: order.email, name: order.shipping_address.name, password: Random.new.rand(100000..999999)
    end
    customer.add_address order.shipping_address
    order.customer = customer
  end

  def after_create(order)
    #发送客户确认邮件
    order.send_email("order_confirm")
  end
end

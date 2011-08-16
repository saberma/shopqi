# encoding: utf-8
class OrderObserver < ActiveRecord::Observer

  def before_save(order)
    # 保存顾客信息
    shop = order.shop
    customer = shop.customers.where(email: order.email).first
    unless customer
      customer = shop.customers.create email: order.email, name: order.billing_address.name
    end
    customer.add_address order.billing_address
    customer.add_address order.shipping_address
    order.customer = customer
  end

  def after_create(order)
    #发送客户确认邮件
    ShopMailer.notify_email(order,OrderDrop.new(order),order.shop.emails.find_by_mail_type('order_confirm')).deliver
  end
end

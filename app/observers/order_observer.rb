# encoding: utf-8
class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    #发送客户确认邮件
    ShopMailer.notify_email(order,OrderDrop.new(order),order.shop.emails.find_by_mail_type('order_confirm')).deliver
  end
end

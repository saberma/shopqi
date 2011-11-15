#encoding: utf-8
#用于发送各网店的邮件,例如：订单提醒等
class ShopMailer < ActionMailer::Base

  def notify_email(email,order_id,mail_type,shop_id)
    order = Order.find(order_id)
    liquid_drop = OrderDrop.new order
    email_template =  order.shop.emails.find_by_mail_type(mail_type)
    liquid_hash = liquid_drop.as_json
    body        = email_template.include_html ? email_template.body_html : email_template.body #判断用text/plain模版还是html模版
    type        = email_template.include_html ? 'text/html' : 'text/plain'
    mail(to: email,from: Shop.find(shop_id).email, body: Liquid::Template.parse(body).render(liquid_hash), subject: Liquid::Template.parse(email_template.title).render(liquid_hash),content_type: type)
  end

end

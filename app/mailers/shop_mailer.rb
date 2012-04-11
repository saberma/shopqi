#encoding: utf-8
#用于发送各网店的邮件,例如：订单提醒等
class ShopMailer < ActionMailer::Base
  default from: Setting.mail_from

  def notify_email(email,order_id,mail_type,shop_id)
    shop = Shop.find(shop_id)
    order = Order.find(order_id)
    liquid_drop = OrderDrop.new order
    email_template =  order.shop.emails.find_by_mail_type(mail_type)
    liquid_hash = liquid_drop.as_json
    body        = email_template.include_html ? email_template.body_html : email_template.body #判断用text/plain模版还是html模版
    type        = email_template.include_html ? 'text/html' : 'text/plain'
    mail(to: email,from: "#{shop.name} <#{shop.email}>", body: Liquid::Template.parse(body).render(liquid_hash.merge('shop' => ShopDrop.new(shop))), subject: Liquid::Template.parse(email_template.title).render(liquid_hash),content_type: type)
  end

  def contact_us(email, body, name, shop_id) # 顾客在商店提交联系表单时发送
    shop = Shop.find(shop_id)
    shop_email = Shop.find(shop_id).email
    message = %Q(
联系表单提交:

意见或建议: #{body}
Email地址: #{email}
    )
    message += "\n姓名: #{name}" unless name.blank?
    mail to: shop.email, subject: "[#{shop.name}]联系表单", body: message
  end

end

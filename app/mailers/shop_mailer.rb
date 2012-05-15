#encoding: utf-8
#用于发送各网店的邮件,例如：订单提醒等
class ShopMailer < ActionMailer::Base
  default from: Setting.mail.from

  def notify_email(mail_type, email, order_id)
    order = Order.find(order_id)
    order_drop = OrderDrop.new order
    shop_drop = ShopDrop.new order.shop
    liquid_hash = order_drop.as_json
    liquid_hash.merge! 'shop' => shop_drop
    liquid_mail mail_type, email, liquid_hash, order
  end

  def ship(mail_type, fulfillment_id) # 给顾客发送发货通知邮件
    fulfillment = OrderFulfillment.find(fulfillment_id)
    order = fulfillment.order
    order_drop = OrderDrop.new order
    shop_drop = ShopDrop.new order.shop
    fulfillment_drop = OrderFulfillmentDrop.new fulfillment
    liquid_hash = order_drop.as_json
    liquid_hash.merge! 'shop' => shop_drop, 'fulfillment' => fulfillment_drop
    liquid_mail mail_type, order.email, liquid_hash, order
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

  def alipay_send_goods_error(fulfillment) # 订单发货信息同步至支付宝时出错(由support发信)
    order = fulfillment.order
    shop = order.shop
    message = %Q(
商店后台将订单#{order.name}的物流信息同步至支付宝时发生错误。

请您登录支付宝，找到商户订单号为 #{order.token} 的交易记录，手动录入以下物流信息:

快递公司:#{fulfillment.tracking_company}
运单号:#{fulfillment.tracking_number}

此类错误只会在网络异常时偶尔发生，如果经常发生，请直接回复此邮件联系我们。
    )
    mail from: Setting.mail.support, to: shop.email, subject: "[#{shop.name}]同步订单#{order.name}发货信息到支付宝时发生错误", body: message
  end

  private
  def liquid_mail(mail_type, email, liquid_hash, order)
    liquid_hash.merge! 'is_email' => true
    shop = order.shop
    email_template =  shop.emails.find_by_mail_type(mail_type)
    body = Liquid::Template.parse(email_template.content).render(liquid_hash)
    subject = Liquid::Template.parse(email_template.title).render(liquid_hash)
    mail from: "#{shop.name} <#{shop.email}>", to: email, subject: subject, body: body, content_type: email_template.content_type
  end

end

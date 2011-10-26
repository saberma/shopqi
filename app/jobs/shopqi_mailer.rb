module ShopqiMailer
  @queue = "shopqi_mailer"

  def self.perform(email,order_id,email_template_id,shop_id)
    order = Order.find(order_id)
    liquid_drop = OrderDrop.new order
    email_template = Email.find(email_template_id)
    ShopMailer.notify_email(email,liquid_drop,email_template,shop_id).deliver
  end
end

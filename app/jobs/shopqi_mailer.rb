module ShopqiMailer
  @queue = "shopqi_mailer"

  def self.perform(email,order_id,mail_type,shop_id)
    ShopMailer.notify_email(email,order_id,mail_type,shop_id).deliver
  end
end

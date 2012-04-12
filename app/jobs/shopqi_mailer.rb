module ShopqiMailer
  @queue = "shopqi_mailer"

  def self.perform(mail_type, email, order_id)
    ShopMailer.notify_email(mail_type, email, order_id).deliver
  end

  module Ship # 发货
    @queue = "shopqi_mailer_ship"

    def self.perform(mail_type, fulfillment_id)
      ShopMailer.ship(mail_type, fulfillment_id).deliver
    end
  end
end

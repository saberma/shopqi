module ShopqiMailer
  QUEUE_NAME = "shopqi_mailer"
  @queue = self.const_get(:QUEUE_NAME)

  def self.perform(mail_type, email, order_id)
    ShopMailer.notify_email(mail_type, email, order_id).deliver
  end

  module Paid # 支付
    @queue = ShopqiMailer::QUEUE_NAME

    def self.perform(transaction_id)
      ShopMailer.paid(transaction_id).deliver
      ShopMailer.paid_notify(transaction_id).deliver
    end
  end

  module Ship # 发货
    @queue = "shopqi_mailer_ship"

    def self.perform(mail_type, fulfillment_id)
      ShopMailer.ship(mail_type, fulfillment_id).deliver
    end
  end
end

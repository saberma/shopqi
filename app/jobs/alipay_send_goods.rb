# encoding: utf-8
module AlipaySendGoods
  @queue = "alipay_send_goods"

  def self.perform(fulfillment_id)
    fulfillment = OrderFulfillment.find(fulfillment_id)
    begin
      order = fulfillment.order
      payment = order.payment
      options = {
        'logistics_name' => fulfillment.tracking_company,
        'invoice_no' => fulfillment.tracking_number,
        'trade_no' => order.trade_no
      }
      unless Gateway::Alipay.send_goods?(options, payment.account, payment.key, payment.email)
        ShopMailer.alipay_send_goods_error(fulfillment).deliver
      end
    rescue => e
      ShopMailer.alipay_send_goods_error(fulfillment).deliver
    end
  end

end

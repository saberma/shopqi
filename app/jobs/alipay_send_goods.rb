# encoding: utf-8
module AlipaySendGoods
  @queue = "alipay_send_goods"

  def self.perform(fulfillment_id)
    fulfillment = OrderFulfillment.find(fulfillment_id)
    order = fulfillment.order
    payment = order.payment
    options = {
      'logistics_name' => fulfillment.tracking_company,
      'invoice_no' => fulfillment.tracking_number,
      'trade_no' => order.trade_no
    }
    Gateway::Alipay.send_goods(options, payment.account, payment.key, payment.email)
  end

end

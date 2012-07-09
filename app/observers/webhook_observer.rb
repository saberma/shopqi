# encoding: utf-8
class WebhookObserver < ActiveRecord::Observer
  observe :order_fulfillment

  def after_create(fulfillment)
    order = fulfillment.order
    if order.fulfilled?
      order.shop.webhooks.orders_fulfilled.each do |webhook|
        response = HTTParty.post(webhook.callback_url, body: fulfillment.to_json)
      end
    end
  end

end

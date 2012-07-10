# encoding: utf-8
class WebhookObserver < ActiveRecord::Observer
  observe :order_fulfillment

  def after_create(fulfillment)
    order = fulfillment.order
    if order.fulfilled?
      order.shop.webhooks.orders_fulfilled.each do |webhook|
        options = { body: fulfillment.to_json }
        options[:headers] = { X_SHOPQI_HMAC_SHA256: sign_hmac(webhook.application.secret, options[:body])} if webhook.application_id
        Resque.enqueue(WebhookWorker, webhook.callback_url, options)
      end
    end
  end

end

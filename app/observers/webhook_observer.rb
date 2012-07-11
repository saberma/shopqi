# encoding: utf-8
class WebhookObserver < ActiveRecord::Observer
  observe :order

  def before_update(order)
    shop = order.shop
    if order.fulfillment_status_changed? and order.fulfilled?
     shop.webhooks.orders_fulfilled.each do |webhook|
        options = { body: Rabl::Renderer.json(order, 'orders/show', view_path: 'app/views/api/v1') }
        options[:headers] = {
          X_SHOPQI_EVENT: KeyValues::Webhook::Event::ORDERS_FULFILLED,
          X_SHOPQI_DOMAIN: shop.shopqi_domain,
          X_SHOPQI_ORDER_ID: order.id.to_s
        }
        options[:headers][:X_SHOPQI_HMAC_SHA256] = sign_hmac(webhook.application.secret, options[:body]) if webhook.application_id
        Resque.enqueue(WebhookWorker, webhook.callback_url, options)
      end
    end
  end

end

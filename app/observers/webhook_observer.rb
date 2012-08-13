# encoding: utf-8
class WebhookObserver < ActiveRecord::Observer
  observe :order

  def before_update(order)
    shop = order.shop
    if order.fulfillment_status_changed? and order.fulfilled?
      shop.webhooks.orders_fulfilled.each do |webhook|
        options = { body: Rabl::Renderer.json(order, 'api/v1/orders/show', view_path: 'app/views') }
        options[:headers] = {
          'x-shopqi-event' => KeyValues::Webhook::Event::ORDERS_FULFILLED,
          'x-shopqi-domain' => shop.shopqi_domain,
          'x-shopqi-order-id' => order.id.to_s
        }
        options[:headers]['x-shopqi-hmac-sha256'] = sign_hmac(webhook.application.secret, options[:body]) if webhook.application_id
        Resque.enqueue(WebhookWorker, webhook.callback_url, options)
      end
    end
  end

end

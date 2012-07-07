# encoding: utf-8
class Admin::WebhooksController < Admin::AppController
  prepend_before_filter :authenticate_user!

  expose(:shop) { current_user.shop }
  expose(:webhooks) { shop.webhooks }
  expose(:webhook)

  def create
    webhook.save
    render json: webhook
  end

  def destroy
    webhook.destroy
    render json: webhook
  end
end

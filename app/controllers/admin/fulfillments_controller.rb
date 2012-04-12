#encoding: utf-8
class Admin::FulfillmentsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout nil

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)
  expose(:fulfillments) { order.fulfillments }
  expose(:fulfillment)

  def set
    if params[:shipped] and !params[:shipped].empty?
      order.fulfillments.create line_item_ids: params[:shipped], tracking_number: params[:tracking_number], tracking_company: params[:tracking_company], notify_customer: params[:notify_customer]
    end
    render json: { fulfillment_status: order.reload.fulfillment_status }
  end

  def show
    render json: fulfillment.to_json(include: {line_items: {methods: :title}})
  end

  def update
    fulfillment.notify_customer = params[:notify_customer]
    fulfillment.save
    render nothing: true
  end
end

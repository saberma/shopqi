#encoding: utf-8
class FulfillmentsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout nil

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)
  expose(:fulfillments) { order.fulfillments }
  expose(:fulfillment)

  def set
    fulfillment_status = order.fulfillment_status
    if params[:shipped] and !params[:shipped].empty?
      order.fulfillments.create line_item_ids: params[:shipped], tracking_number: params[:tracking_number], tracking_company: params[:tracking_company]
      fulfillment_status = (order.line_items.unshipped.size > 0) ? :partial : :fulfilled
      order.update_attribute :fulfillment_status, fulfillment_status
    end
    render json: { fulfillment_status: fulfillment_status }
  end

  def show
    render json: fulfillment.to_json(include: {line_items: {methods: :title}})
  end

  def update
    fulfillment.save
    render nothing: true
  end
end

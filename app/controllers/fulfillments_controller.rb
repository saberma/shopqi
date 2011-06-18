#encoding: utf-8
class FulfillmentsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout nil

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)

  def set
    fulfillment_status = order.fulfillment_status
    if params[:shipped] and !params[:shipped].empty?
      attrs = params[:shipped].map {|id| {line_item_ids: [id]} }
      order.fulfillments.create attrs
      fulfillment_status = (order.line_items.unshipped.size > 0) ? :partial : :fulfilled
      order.update_attribute :fulfillment_status, fulfillment_status
    end
    render json: { fulfillment_status: fulfillment_status }
  end
end

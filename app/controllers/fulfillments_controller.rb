#encoding: utf-8
class FulfillmentsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout nil

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)

  def set
    if params[:shipped] and !params[:shipped].empty?
      attrs = params[:shipped].map {|id| {line_item_ids: [id]} }
      order.fulfillments.create attrs
    end
    render :nothing => true
  end
end

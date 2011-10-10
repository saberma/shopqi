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
      order.fulfillments.create line_item_ids: params[:shipped], tracking_number: params[:tracking_number], tracking_company: params[:tracking_company]
      order.send_email('ship_confirm') if params[:notify_customer] == 'true' #当选中通知顾客时，发送邮件
    end
    render json: { fulfillment_status: order.reload.fulfillment_status }
  end

  def show
    render json: fulfillment.to_json(include: {line_items: {methods: :title}})
  end

  def update
    #若有更改则发送邮件
    if fulfillment.changed? && fulfillment.save
      order.send_email('ship_update') if params[:notify_customer] == 'true' #当选中通知顾客时，发送邮件
    end
    render nothing: true
  end
end

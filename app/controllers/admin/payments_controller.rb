#coding: utf-8
class Admin::PaymentsController < Admin::AppController
  layout 'admin'
  prepend_before_filter :authenticate_user!
  expose(:shop){ current_user.shop }
  expose(:payments){ shop.payments }
  expose(:payment_alipay){ shop.payments.where(:payment_type_id => 1).first || shop.payments.new}
  expose(:payment)
  expose(:policy_types){ KeyValues::PolicyType.all }
  expose(:policies){ shop.policies }
  expose(:all_custom_types){ KeyValues::Payment::Custom.all.map{|c|[c.name,c.name]}}
  expose(:custom_payments){ Payment.where(payment_type_id: nil).all }
  expose(:selected_custom_types){ custom_payments.map{|c|[c.name,c.name]} }
  expose(:custom_types){ all_custom_types - selected_custom_types }

  def index
    if shop.policies.empty?
      policy_types.each  do |type|
        shop.policies.build title: type.name
      end
    end
  end

  def create
    #处理支付宝部分
    if params[:payment][:payment_type_id]
      payment_alipay.attributes = params[:payment]
      payment_alipay.save
      if payment_alipay.save
        redirect_to payments_path,  notice: notice_msg
      else
        render action: 'index'
      end
    #处理普通支付部分
    else
      payment.attributes = params[:payment]
      payment.save
      render json: payment
    end
  end

  def update
    payment.attributes = params[:payment]
    if payment.save
      respond_to do |format|
        format.html { redirect_to payments_path,  notice: notice_msg }
        format.json { render json: payment }
      end
    else
      render action: 'index'
    end
  end

  def destroy
    payment.destroy
    respond_to do |format|
      format.js { render js: "window.location='#{payments_path}';msg('删除成功！')" }
      format.json { render json: payment }
    end
  end
end

#coding: utf-8
class PaymentsController < ApplicationController
  layout 'admin'
  prepend_before_filter :authenticate_user!
  expose(:shop){ current_user.shop }
  expose(:payments){ shop.payments }
  expose(:payment_alipay){ shop.payments.where(:payment_type_id => 1).first || shop.payments.new}
  expose(:payment)
  expose(:policy_types){ KeyValues::PolicyType.all }
  expose(:policies){ shop.policies }

  def index
    if shop.policies.empty?
      policy_types.each  do |type|
        shop.policies.build title: type.name
      end
    end
  end

  def create
    payment_alipay.attributes = params[:payment]
    payment_alipay.save
    if payment_alipay.save
      redirect_to payments_path,  notice: notice_msg
    else
      render action: 'index'
    end
  end

  def update
    payment_alipay.attributes = params[:payment]
    if payment_alipay.save
      redirect_to payments_path,  notice: notice_msg
    else
      render action: 'index'
    end
  end

  def destroy
    payment.destroy
    render js: "window.location='#{payments_path}';msg('删除成功！')"
  end
end

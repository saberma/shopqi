class AccountController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout :determine_layout

  expose(:shop){ current_user.shop }
  expose(:users){ current_user.shop.users}
  expose(:user)
  expose(:plan_types){KeyValues::Plan::Type.all}
  expose(:plan_type){KeyValues::Plan::Type.find_by_code(params[:code])}

  def change_ownership
    if params[:user]
      current_user.admin = false
      u = User.find(params[:user][:id])
      u.admin = true
      u.save
      current_user.save
    end
    redirect_to account_index_path
  end

  #用于用户升级账户
  def confirm_plan
    @consumption = shop.consumptions.where(plan_type_id: plan_type.id, status: false, quantity: params[:consumption][:quantity], price: plan_type.price).first || shop.consumptions.create( plan_type_id: plan_type.id,price: plan_type.price, quantity: params[:consumption][:quantity])
  end

  def change_plan
  end

  def notify
    notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
    if notification.acknowledge && valid?(notification)
      @consumption = Consumption.find_by_token(notification.out_trade_no)
      @consumption.pay! if notification.status == "TRADE_FINISHED"
      render :text => "success"
    else
      render :text => "fail"
    end
  end

  protected
  def determine_layout
    %w(confirm_plan change_plan).include?(action_name) ? "application" : "admin"
  end

  private
  # 确认验证请求是从支付宝发出的
  def valid?(notification)
    url = "http://notify.alipay.com/trade/notify_query.do"
    result = HTTParty.get(url, :query => {:partner => ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT, :notify_id => notification.notify_id}).body
    result == 'true'
  end

end

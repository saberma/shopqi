#encoding: utf-8
class Admin::AccountController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: [:notify]
  layout :determine_layout

  expose(:shop){ current_user.shop }
  expose(:users){ current_user.shop.users}
  expose(:users_json){ current_user.shop.users.delete_if{|u| !u.id}.to_json( include: :permissions , methods: [:default_avatar_image_url])}
  expose(:user)
  expose(:plan_types){KeyValues::Plan::Type.all}
  expose(:plan_type){KeyValues::Plan::Type.find_by_code(params[:code])}
  expose(:current_plan_type){ shop.plan_type }
  expose(:skus_size){ shop.variants.size }
  expose(:cancel_reason)
  expose(:cancel_reason_options){ KeyValues::CancelReason.options }
  expose(:resource_types){ KeyValues::ResourceType.all }
  expose(:resource_hashs){ KeyValues::ResourceType.all.map(&:resources).flatten.group_by{|r|r.resource_type_id} }

  def change_ownership
    if params[:user]
      User.transaction do
        current_user.admin = false
        current_user.prepare_resources
        u = shop.users.find(params[:user][:id])
        u.admin = true
        u.permissions.clear
        u.save
        current_user.save
      end
    end
    redirect_to account_index_path
  end

  begin '变更方案'

    def change_plan
    end

    def confirm_plan #用于用户升级账户
      quantity = params[:consumption][:quantity]
      @consumption = shop.consumptions.where(plan_type_id: plan_type.id, status: false, quantity: quantity).first || shop.consumptions.create(plan_type_id: plan_type.id, quantity: quantity)
    end

  end

  begin '续费'

    def pay_plan
    end

    def confirm_pay_plan
      quantity = params[:consumption][:quantity]
      @consumption = shop.consumptions.where(plan_type_id: shop.plan_type.id, status: false, quantity: quantity).first || shop.consumptions.create(plan_type_id: shop.plan_type.id, quantity: quantity)
    end

  end

  begin 'from pay gateway'

    def notify
      notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(request.raw_post)
      if notification.acknowledge && valid?(notification)
        @consumption = Consumption.find_by_token(notification.out_trade_no)
        @consumption.pay! if notification.status == "TRADE_FINISHED"
        render text: "success"
      else
        render text: "fail"
      end
    end

    def done # 支付后从浏览器前台直接返回(return_url)
      pay_return = ActiveMerchant::Billing::Integrations::Alipay::Return.new(request.query_string)
      @consumption = Consumption.find_by_token(pay_return.order)
      if @consumption
        @consumption.pay! unless @consumption.status # 要支持重复请求
        flash[:notice] = "支付成功!"
      else
        raise pay_return.message
      end
      redirect_to account_index_path
    end

  end

  def cancel #删除账户页面
  end

  def destroy
    cancel_reason.save  #保存反馈信息
    content  ="您好！您的商店已经关闭，感谢您一直以来对我们的支持。谢谢。"
    phone = shop.users.where(admin: true).first.phone
    if shop.phone && !development? && !test?
      SMS.safe_send phone, content, request.remote_ip #给商店拥有者发送短信
    end
    shop.update_attribute(:access_enabled,false)
    Resque.enqueue_in(90.days, DeleteShop, shop.id)
    flash[:alert] = "您的商店已成功删除！"
    redirect_to home_message_path
  end

  protected
  def determine_layout
    %w(change_plan confirm_plan pay_plan confirm_pay_plan cancel).include?(action_name) ? "application" : "admin"
  end

  private
  # 确认验证请求是从支付宝发出的
  def valid?(notification)
    url = "http://notify.alipay.com/trade/notify_query.do"
    result = HTTParty.get(url, :query => {:partner => ActiveMerchant::Billing::Integrations::Alipay::ACCOUNT, :notify_id => notification.notify_id}).body
    result == 'true'
  end

end

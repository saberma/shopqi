#encoding: utf-8
class Shopqi::RegistrationsController < Devise::RegistrationsController
  include Shopqi::HomeHelper
  skip_before_filter :force_domain # 不需要重定向
  before_filter :clear_current_user_for_observer
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  expose(:signup_source_options) { KeyValues::Shop::SignupSource.options }

  def new
    params[:plan] ||= :professional
    (render action: :forbid and return) unless Setting.can_register
  end

  def create
    data = {errors: {}}
    if is_code_valid? # 手机校验码(测试环境下不校验)
      session[:verify_code] = nil
      build_resource
      resource.shop.themes.first.theme_id ||= Theme.default.id
      resource.shop.email = resource.email #商店默认邮箱为注册时用户邮箱
      if resource.save
        Rails.cache.write(registered_cache_key, true, expires_in: 24.hours) # 避免重复注册
        data[:token] = resource.authentication_token
      else
        data[:errors] = resource.errors
      end
    else
      data[:errors] = {verify_code: '手机校验码不正确'}
    end
    render json: data.to_json
  end

  def check_availability
    render text: ShopDomain.exists?(host: "#{params[:domain]}")
  end

  def verify_code
    receiver = params[:phone]
    session[:verify_code] ||= Random.new.rand(1000..9999)
    content = "您好!您的手机验证码为:#{session[:verify_code]}"
    if development?
      puts content # 开发时直接将验证码显示在后台
    else
      SMS.safe_send receiver, content, request.remote_ip
    end
    render nothing: true
  end

  private
  def is_code_valid? # 测试环境，或者还没有注册过的，则不需要校验码
    Rails.env.test? or !is_registered? or params[:verify_code].to_i == session[:verify_code]
  end

  def clear_current_user_for_observer # 线程处理完其他商店用户操作后可能会保持current_user类变量
    ActivityObserver.current_user = nil
  end
end

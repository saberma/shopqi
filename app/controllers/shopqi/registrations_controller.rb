#encoding: utf-8
class Shopqi::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :force_domain # 不需要重定向
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  expose(:signup_source_options) { KeyValues::Shop::SignupSource.options }

  def create
    data = {errors: {}}
    if params[:verify_code].to_i == session[:verify_code] or Rails.env.test? # 手机校验码(测试环境下不校验)
      session[:verify_code] = nil
      build_resource
      resource.shop.themes.first.theme_id ||= Theme.default.id
      if resource.save
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
    SMS.safe_send receiver, content, request.remote_ip
    render nothing: true
  end
end

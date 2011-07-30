#encoding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  def create
    errors = {}
    if params[:verify_code].to_i == session[:verify_code] # 手机校验码
      build_resource
      if resource.save
        sign_in(resource_name, resource)
      else
       errors = resource.errors
      end
    else
      errors = {verify_code: '手机校验码不正确'}
    end
    render json: errors.to_json
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

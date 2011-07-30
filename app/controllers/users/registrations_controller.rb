#encoding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController
  layout 'shopqi'

  expose(:themes_json) do
    Theme.all.take(7) do |result, theme|
      result << { theme: theme.attributes }; result
    end.to_json
  end

  def create
    build_resource

    if resource.save
      sign_in(resource_name, resource)
      render json: {}
    else
      render json: resource.errors.to_json
    end
  end

  def check_availability
    render text: ShopDomain.exists?(host: "#{params[:domain]}")
  end

  def verify_code
    session[:verify_code] ||= Random.new.rand(1000..9999)
    config = YAML::load_file(Rails.root.join('config/sms.yml'))
    url = "http://#{config['smsapi']}/#{config['charset']}/interface/send_sms.aspx"
    receiver = params[:phone]
    content = "您好!您的手机验证码为:#{session[:verify_code]}"
    res = Net::HTTP.post_form(URI.parse(url), username: config['username'], password: config['password'], receiver: receiver, content: content)
    p res.body
    render nothing: true
  end
end

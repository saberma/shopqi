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
    receiver = params[:phone]
    ip_key = "sending_from:#{request.remote_ip}" # 每个ip60秒最多发1次，注意部署时proxy的设置，以使remote_ip生效
    phone_key = "sending_to:#{receiver}" # 每个phone一天内最多发10次
    Rails.cache.fetch ip_key, expires_in: 1.minute do
      send_times = Rails.cache.fetch(phone_key, expires_in: 24.hours){ 10 }
      if send_times > 0
        Rails.cache.decrement phone_key
        session[:verify_code] ||= Random.new.rand(1000..9999)
        config = YAML::load_file(Rails.root.join('config/sms.yml'))
        url = "http://#{config['smsapi']}/#{config['charset']}/interface/send_sms.aspx"
        content = "您好!您的手机验证码为:#{session[:verify_code]}"
        res = Net::HTTP.post_form(URI.parse(url), username: config['username'], password: config['password'], receiver: receiver, content: content)
        res.body
      end
    end
    render nothing: true
  end
end

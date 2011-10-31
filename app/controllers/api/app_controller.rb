class Api::AppController < ActionController::Base # API接口
  layout nil #默认不需要layout，使用liquid
  before_filter :authenticate

  protected
  def authenticate
    myshopqi = Shop.at( request.host)
    authenticate_or_request_with_http_basic do |username, password|
      myshopqi.api_clients.exists?(api_key: username,password: password)
    end
  end
end

class Api::AppController < ActionController::Base # API接口
  layout nil #默认不需要layout，使用liquid
  before_filter :authenticate
  before_filter :login_or_oauth_required

  protected
  def authenticate
    myshopqi = Shop.at( request.host)
    authenticate_or_request_with_http_basic do |username, password|
      myshopqi.api_clients.exists?(api_key: username,password: password)
    end
  end

  def login_or_oauth_required
    token = OAuth2::Provider.access_token(nil, [], request)
    unless token.valid?
      render json: {error: 'No soup for you!'}
    end
  end
end

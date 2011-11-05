class Api::AppController < ActionController::Base # API接口
  layout nil #默认不需要layout，使用liquid
  before_filter :authenticate
  before_filter :login_or_oauth_required

  protected
  def authenticate
    unless session[:shop]
      myshopqi = Shop.at( request.host)
      authenticate_or_request_with_http_basic do |username, password|
        if myshopqi.api_clients.exists?(api_key: username,password: password)
          session[:shop] ||=  myshopqi.as_json(only: [:deadline, :created_at, :updated_at, :name])['shop']
        else
          render json: {error: '[API] Invalid API key or permission token (unrecognized login or wrong password)'}
        end
      end
    end
  end

  def login_or_oauth_required
    unless session[:shop]
      token = OAuth2::Provider.access_token(nil, [], request)
      unless token.valid?
        render json: {error: '[API] Invalid API key or permission token (unrecognized login or wrong password)'}
      else
        session[:shop] ||= token.owner.as_json(only: [:deadline, :created_at, :updated_at, :name])['shop']
      end
    end
  end
end

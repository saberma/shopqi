class OauthController < Admin::AppController
  prepend_before_filter :authenticate_user!, except: :access_token

  expose(:shop) { current_user.shop }

  def authorize # 返回authorize_code
    @oauth2 = OAuth2::Provider.parse(shop, request)
    #response.headers = @oauth2.response_headers
    #response.status = @oauth2.response_status
    redirect_to @oauth2.redirect_uri  if @oauth2.redirect?
  end

  def access_token # 返回access_token
    @oauth2 = OAuth2::Provider.parse(nil, request)
    render text: @oauth2.response_body
  end

  def allow
    @auth = OAuth2::Provider::Authorization.new(shop, params)
    if params['allow'] == '1'
      @auth.grant_access!
    else
      @auth.deny_access!
    end
    redirect_to @auth.redirect_uri
  end

  protected
  # Override this to match your authorization page form
  # It currently expects a checkbox called authorize
  # def user_authorizes_token?
  #   params[:authorize] == '1'
  # end

  # should authenticate and return a user if valid password.
  # This example should work with most Authlogic or Devise. Uncomment it
  # def authenticate_user(username,password)
  #   user = User.find_by_email params[:username]
  #   if user && user.valid_password?(params[:password])
  #     user
  #   else
  #     nil
  #   end
  # end

end

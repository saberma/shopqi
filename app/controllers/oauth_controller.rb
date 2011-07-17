require 'oauth/controllers/provider_controller'
class OauthController < ApplicationController
  # oauth plugin使用了login_required方法
  alias :logged_in? :user_signed_in?
  alias :login_required :authenticate_user!
  include OAuth::Controllers::ProviderController

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

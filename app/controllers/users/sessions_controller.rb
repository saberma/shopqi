#encoding: utf-8
class Users::SessionsController < Devise::SessionsController
  before_filter :get_host, only: :create

  private
  def get_host # 设置的域名参数在 User.find_for_database_authentication 中使用
    params[:user][:host] = request.host
  end
end

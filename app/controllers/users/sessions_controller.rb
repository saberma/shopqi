#encoding: utf-8
class Users::SessionsController < Devise::SessionsController
  #before_filter :get_host, only: :create
  before_filter :force_domain # 登录信息需要用到https，必须重定向至 .myshopqi.com

  private
  def force_domain # ApplicationController.force_domain()要保持一致
    myshopqi = Shop.at(request.host).domains.myshopqi
    redirect_to "#{request.protocol}#{myshopqi.host}#{request.port_string}#{request.path}" if request.host != myshopqi.host
  end

  def after_sign_out_path_for(resource)
    home_message_path
  end
end

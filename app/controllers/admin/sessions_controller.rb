#encoding: utf-8
class Admin::SessionsController < Devise::SessionsController
  #before_filter :get_host, only: :create
  before_filter :check_shop_access_enabled
  before_filter :force_domain # 登录信息需要用到https，必须重定向至 .myshopqi.com

  private
  def check_shop_access_enabled
    shop = Shop.at(request.host)
    if !shop.access_enabled
      render template: 'shared/no_shop.html', content_type: "text/html", status: 404, layout: nil
    end
  end

  def force_domain # ApplicationController.force_domain()要保持一致
    myshopqi = Shop.at(request.host).domains.myshopqi
    redirect_to "#{request.protocol}#{myshopqi.host}#{request.port_string}#{request.path}" if request.host != myshopqi.host
  end

  def after_sign_out_path_for(resource)
    home_message_path
  end
end

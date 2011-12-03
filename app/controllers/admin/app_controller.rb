# encoding: utf-8
class Admin::AppController < ActionController::Base # 后台管理/admin
  protect_from_forgery
  #### 注意: devise login, register控制器继承自此，所以设置过滤器的时候要考虑是否要在他们的控制器中skip掉 #####
  before_filter :check_shop_access_enabled
  before_filter :check_permission
  before_filter :set_current_user_for_observer
  before_filter :force_domain # 后台管理需要用到https，必须重定向至 .myshopqi.com

  #不要在输入项的后面插入field_with_errors div，会破坏布局(比如[价格]输入项后面带'元'，'元'字会被移至下一行)
  #ActionView::Base.field_error_proc = proc { |input, instance| input }
  protected
  def check_permission
    resource_code = controller_name
    if controller_name =~ /collection|product/  #集合属于商品管理权限范围
      resource_code = 'products'
    elsif controller_name == 'links'
      resource_code = 'link_lists'
    elsif controller_name =~ /assets|theme/
      resource_code = 'themes'
    elsif controller_name.in?(['articles','blogs','comments'])
      resource_code = 'pages'
    elsif controller_name.in?(['fulfillments','transactions'])
      resource_code = 'orders'
    elsif controller_name.in?(['customer_groups','customers'])
      resource_code = 'customers'
    elsif controller_name.in?(['shops','countries','payments','emails','domains']) || controller_name =~ /shipping/
      resource_code = 'preferences'
    elsif controller_name.in?(['api_clients'])
      resource_code = 'applications'
    end
    render template: 'shared/access_deny', layout: 'application' if current_user && !current_user.has_right?(resource_code)
  end

  def check_shop_access_enabled
    shop = Shop.at(request.host)
    if !shop.access_enabled
      render template: 'shared/no_shop.html', content_type: "text/html", status: 404, layout: nil
    end
  end

  def force_domain # Users::SessionsController.force_domain()要保持一致
    myshopqi = Shop.at( request.host).domains.myshopqi
    redirect_to "#{request.protocol}#{myshopqi.host}#{request.port_string}#{request.path}" if request.host != myshopqi.host
  end

  def notice_msg
    I18n.t("flash.actions.#{action_name}.notice")
  end

  def set_current_user_for_observer
    ActivityObserver.current_user = current_user
  end

  expose(:tasks) { current_user.shop.tasks }
  expose(:tasks_json) { tasks.to_json(except: [:created_at, :updated_at]) }

end

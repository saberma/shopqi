# encoding: utf-8
class ApplicationController < ActionController::Base # 后台管理/admin
  protect_from_forgery
  before_filter :set_current_user_for_observer
  before_filter :force_domain # 后台管理需要用到https，必须重定向至 .myshopqi.com

  #不要在输入项的后面插入field_with_errors div，会破坏布局(比如[价格]输入项后面带'元'，'元'字会被移至下一行)
  #ActionView::Base.field_error_proc = proc { |input, instance| input }
  protected
  def force_domain # Users::SessionsController.force_domain()要保持一致
    myshopqi = Shop.at(request.host).domains.myshopqi
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

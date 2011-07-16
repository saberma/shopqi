# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  # oauth plugin使用了login_required方法
  alias :logged_in? :user_signed_in?
  alias :login_required :authenticate_user!

  #不要在输入项的后面插入field_with_errors div，会破坏布局(比如[价格]输入项后面带'元'，'元'字会被移至下一行)
  #ActionView::Base.field_error_proc = proc { |input, instance| input }
  protected
  def notice_msg
    I18n.t("flash.actions.#{action_name}.notice")
  end
end

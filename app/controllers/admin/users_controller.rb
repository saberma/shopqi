#encoding: utf-8
class Admin::UsersController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:users){current_user.shop.users}
  expose(:user)
  expose(:user_json){ {name: user.name,email:user.email,is_current_user:current_user.id == user.id,id:user.id}.to_json}

  def update
    #若没填密码，则不需要更新密码
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank? && params[:user][:password].blank?

    if user.save
      sign_in user
      redirect_to account_index_path,notice: I18n.t("flash.actions.#{action_name}.notice")
    else
      render action:"edit"
    end
  end

  def create
    user.shop = current_user.shop
    user.password = '666666'
    user.admin = false
    if user.save
      if request.xhr?
        flash[:notice] = "新增用户成功！"
        render js: "window.location = '#{account_index_path}';msg('#{flash[:notice]}');"
      end
    else
      render js: "error_msg('新增用户失败:邮箱格式不正确')"
    end
  end

  def destroy
    user.destroy
    render json: user
  end

  def show
    respond_to do |format|
      format.json {render json: user_json}
    end
  end

end

#encoding: utf-8
class UsersController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:users){current_user.shop.users}
  expose(:user)

  def update
    if user.save
      redirect_to users_path
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
    end
  end

  def destroy
    user.destroy
    flash[:notice] = "删除用户成功！"
    render js: "window.location = '#{account_index_path}';msg('#{flash[:notice]}');"
  end


end

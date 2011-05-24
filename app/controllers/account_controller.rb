class AccountController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:users){ current_user.shop.users}
  expose(:user)

  def change_ownership
    current_user.admin = false
    u = User.find(params[:user][:id])
    u.admin = true
    u.save
    current_user.save
    redirect_to account_index_path
  end

end

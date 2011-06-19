class EmailsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:emails){ shop.emails }
  expose(:email)
  def index
  end

  def update
    p params[:email][:body]
    email.save
    redirect_to admin_notifications_path , notice: notice_msg
  end
end

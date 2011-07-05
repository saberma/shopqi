# encoding: utf-8
class ShopsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin', only: :edit

  expose(:shop) { current_user.shop }

  def update
    if params[:shop][:order_number_format] && !params[:shop][:order_number_format].include?('{{number}}')
      params[:shop][:order_number_format] = '#{{number}}'
    end
    shop.update_attributes(params[:shop])
    respond_to do |format|
      format.html {redirect_to admin_general_preferences_path, notice: notice_msg}
      format.js   {render nothing: true}
    end
  end

end

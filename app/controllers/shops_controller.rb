# encoding: utf-8
class ShopsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin', only: :edit

  expose(:shop) { current_user.shop }

  def update
    shop.update_attributes(params[:shop])
    flash[:notice] = I18n.t("flash.actions.#{action_name}.notice")
    redirect_to admin_general_preferences_path
  end

end

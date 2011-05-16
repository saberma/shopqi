# encoding: utf-8
class PagesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:pages) { current_user.shop.pages }
  expose(:page)

  expose(:blogs) { current_user.shop.blogs }

  def create
    page.save
    redirect_to page_path(page)
  end

  def update
    page.save
    flash.now[:notice] = I18n.t("flash.actions.#{action_name}.notice")
    respond_to do |format|
      format.html { redirect_to page_path(page) }
      format.js { render :template => "shared/msg" }
    end
  end

  def destroy
    page.destroy
  end
end

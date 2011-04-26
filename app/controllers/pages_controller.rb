class PagesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:pages) { current_user.shop.pages }
  expose(:page)

  def create
    page.save
    redirect_to page_path(page)
  end

  def update
    page.save
    respond_to do |format|
      format.html { redirect_to page_path(page) }
      format.js
    end
  end

  def destroy
    page.destroy
  end
end

#encoding: utf-8
class HomeController < ApplicationController
  prepend_before_filter :authenticate_user! ,:only => [:dashboard]
  layout 'admin', only: [:dashboard,:query]

  expose(:shop) { current_user.shop }

  expose(:results) do
    if params[:q].blank?
      nil
    else
      ThinkingSphinx.search params[:q], classes: [Product,Order, Article, Page,Blog], with: { shop_id: shop.id }
    end
  end

  def index
  end

  # 网店管理首页
  def dashboard
  end

  def query
  end
end

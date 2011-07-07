#encoding: utf-8
class HomeController < ApplicationController
  include HomeHelper
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

  expose(:results_json) do
    if params[:term].blank?
      nil
    else
      objs = ThinkingSphinx.search params[:term], classes: [Product, Article,Order, Page,Blog], with: { shop_id: shop.id },page: 1, per_page:10
      objs.map{|obj|{kind: obj.class.to_s,title: obj.title, url: url_for_lookup(obj.class,obj)}}
    end
  end

  def index
  end

  # 网店管理首页
  def dashboard
  end

  def query
    p results_json
    respond_to do |format|
      format.html
      format.json { render json: results_json}
    end
  end

end

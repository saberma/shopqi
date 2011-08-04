#encoding: utf-8
class HomeController < ApplicationController
  include HomeHelper
  prepend_before_filter :authenticate_user! ,:only => [:dashboard, :query]
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

  expose(:statistics){
    today = shop.orders.recent(1)
    yesterday = shop.orders.recent(2) - today
    last_week_begin = Date.today.advance(days: -7).beginning_of_week
    last_week_end = Date.today.advance(days: -7).end_of_week
    last_week = shop.orders.between(last_week_begin,last_week_end)
    total = shop.orders.all
    total_product = shop.products.all
    skus_size = shop.variants.where("sku != ''").size
    {
      today: { price: today.map(&:total_price).inject(0,:+),size: today.size,des: '今天'},
      yesterday: { price: yesterday.map(&:total_price).inject(0,:+),size: yesterday.size,des: '昨天'},
      last_week: { price: last_week.map(&:total_price).inject(0,:+),size: last_week.size,des: '上周'},
      total: { size: total.size,des: '订单总量'},
      total_product: { size: total_product.size,des: '总商品数'},
      skus: {size: skus_size, des: 'SKUS'}

    }
  }

  expose(:recent_orders){
    shop.orders.limit(5).all
  }

  expose(:recent_comments){
    shop.comments.limit(5).where("status != 'spam'").order("created_at desc").all
  }

  expose(:activities){
    shop.activities.limit(10)
  }

  def index
  end

  def dashboard # 网店管理首页
    render :guide if shop.tasks.incomplete.size > 0
  end

  def complete_task # 完成新手指引任务
    task = shop.tasks.where(name: params[:name]).first
    task.update_attributes! completed: true
    render nothing: true
  end

  def query
    respond_to do |format|
      format.html
      format.json { render json: results_json}
    end
  end

end

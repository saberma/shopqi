# encoding: utf-8
class Shopqi::AppController < ActionController::Base
  before_filter :force_www # shopqi.com 永久重定向至 www.shopqi.com # issues#291

  def force_www # issues#291
    redirect_to({subdomain: 'www'}, status: :moved_permanently) if request.subdomain.blank?
  end
end

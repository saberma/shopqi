#encoding: utf-8
class Shopqi::HomeController < Shopqi::AppController # 官网首页
  layout 'shopqi'

  def agreement
    render layout: nil
  end

end

#encoding: utf-8
class Shopqi::HomeController < Shopqi::AppController # 官网首页
  layout 'shopqi'
  expose(:plan_types){KeyValues::Plan::Type.all.reverse}

  def agreement
    render layout: nil
  end

  def no_shop
    render template: 'shared/no_shop.html', content_type: "text/html", status: 404, layout: nil
  end

  def no_page
    render status: 404
  end

  def robots
    robots = File.read(Rails.root.join("public/robots/shopqi_robots.txt"))
    render text: robots, layout: false, content_type: "text/plain"
  end

end

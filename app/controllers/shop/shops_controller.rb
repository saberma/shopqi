# encoding: utf-8
#class Shop::ShopsController < Shop::ApplicationController #warning: toplevel constant ApplicationController referenced by
class Shop::ShopsController < Shop::AppController
  include Admin::ShopsHelper
  skip_before_filter :password_protected, only: [:password, :themes, :asset, :robots]
  skip_before_filter :must_has_theme, only: [:password, :themes, :asset, :robots]

  expose(:shop) do
    if params[:id]
      Shop.find(params[:id]) #checkout页面
    else
      Shop.at(request.host)
    end
  end

  def show
    assign = template_assign
    html = Liquid::Template.parse(layout_content).render(shop_assign('index', assign))
    render text: html
  end

  def unkown
    raise '404'
  end

  # 附件
  def asset
    asset = "#{params[:file]}.#{params[:format]}" # style.css
    theme = shop.themes.find(params[:theme_id])
    html = Liquid::Template.parse(File.read(theme.asset_path(asset))).render(asset_assign)
    render text: html
  end

  def password # 提示密码
    if request.post?
      if params[:password] == shop.password
        session['storefront_digest'] = true
        redirect_to '/'
      else
        flash[:error] = '密码不正确，请重试.'
      end
    end
  end

  def robots
    robots = File.read(Rails.root.join("public/robots/shop_robots.txt"))
    render text: robots, layout: false, content_type: "text/plain"
  end

end

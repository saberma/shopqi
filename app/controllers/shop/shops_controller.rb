# encoding: utf-8
#class Shop::ShopsController < Shop::ApplicationController #warning: toplevel constant ApplicationController referenced by
class Shop::ShopsController < Shop::AppController
  include Admin::ShopsHelper
  skip_before_filter :password_protected, only: [:password, :unavailable, :themes, :asset, :robots]
  skip_before_filter :must_has_theme, only: [:password, :themes, :asset, :robots]
  skip_before_filter :check_shop_avaliable, only: [:unavailable, :robots]

  expose(:shop) do
    if params[:id]
      Shop.find(params[:id]) #checkout页面
    else
      Shop.at(request.host)
    end
  end

  def show
    assign = template_assign('template' => 'index')
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  def unkown
    raise ActionController::RoutingError.new(params[:unkown])
  end

  # 附件
  def asset
    asset = "#{params[:file]}.#{params[:format]}" # style.css
    theme = shop.themes.find(params[:theme_id])
    assign = { 'shop' => ShopDrop.new(shop, theme), 'settings' => SettingsDrop.new(theme) }
    html = Liquid::Template.parse(File.read(theme.asset_path(asset))).render(assign)
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

  def favicon # 网站图标
    path = theme.asset_path_without_liquid('favicon.ico')
    path = Rails.root.join('public/favicon.ico') unless File.exists?(path)
    send_file path, content_type: 'image/x-icon', disposition: 'inline'
  end

  def unavailable # 提示商店已过期，暂时无法访问
  end

end

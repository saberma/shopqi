# encoding: utf-8
#class Shop::ShopsController < Shop::ApplicationController #warning: toplevel constant ApplicationController referenced by
class Shop::ShopsController < Shop::AppController
  skip_before_filter :password_protected, only: :password

  expose(:shop) do
    if params[:id]
      Shop.find(params[:id]) #checkout页面
    else
      Shop.at(request.host)
    end
  end

  def show
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign)
    render text: html
  end

  # 附件
  def asset
    asset = "#{params[:file]}.#{params[:format]}" # style.css
    html = Liquid::Template.parse(File.read(shop.theme.asset_path(asset))).render(asset_assign)
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
end

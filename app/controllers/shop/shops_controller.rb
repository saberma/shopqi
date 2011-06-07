# encoding: utf-8
class Shop::ShopsController < Shop::ApplicationController
  layout nil

  expose(:shop) do
    if params[:id]
      Shop.find(params[:id]) #checkout页面
    else
      Shop.where(permanent_domain: request.subdomain).first
    end
  end

  def show
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign)
    render text: html, layout: nil
  end

  # 附件
  def asset
    asset = "#{params[:file]}.#{params[:format]}" # style.css
    html = Liquid::Template.parse(File.read(shop.theme.asset_path(asset))).render(asset_assign)
    render text: html, layout: nil
  end
end

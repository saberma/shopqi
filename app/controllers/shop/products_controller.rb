#encoding: utf-8
class Shop::ProductsController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }
  expose(:product) { shop.products.where(handle: params[:handle]).first }

  def show
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('product', product))
    render text: html
  end
end

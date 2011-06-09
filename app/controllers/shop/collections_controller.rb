#encoding: utf-8
class Shop::CollectionsController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }
  expose(:product) { shop.products.where(handle: params[:handle]).first }

  def show
    template_assign = { 'product' => ProductDrop.new(product) }
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('product', template_assign))
    render text: html
  end
end

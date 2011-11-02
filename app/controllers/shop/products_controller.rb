#encoding: utf-8
class Shop::ProductsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }
  expose(:product) { shop.products.where(handle: params[:handle]).first }

  def show
    assign = template_assign('product' => ProductDrop.new(product))
    html = Liquid::Template.parse(layout_content).render(shop_assign('product', assign))
    render text: html
  end
end

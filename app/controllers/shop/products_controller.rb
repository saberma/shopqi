#encoding: utf-8
class Shop::ProductsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }
  expose(:product) { shop.products.handle!(params[:handle]) }

  def show
    respond_to do |format|
      format.html {
        assign = template_assign('product' => ProductDrop.new(product))
        html = Liquid::Template.parse(layout_content).render(shop_assign('product', assign))
        render text: html
      }
      format.js {
        render json: product.shop_as_json
      }
    end
  end
end

#encoding: utf-8
class Shop::ProductsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }
  expose(:product) { shop.products.handle!(params[:handle]) }

  def show
    respond_to do |format|
      format.html {
        variable = { 'product' => ProductDrop.new(product) }
        variable['collection'] = CollectionDrop.new(shop.collection(params[:collection_handle])) if params[:collection_handle]
        assign = template_assign(variable)
        html = Liquid::Template.parse(layout_content).render(shop_assign('product', assign))
        render text: html
      }
      format.js {
        render json: product.shop_as_json
      }
    end
  end
end
CollectionsDrop

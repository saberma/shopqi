#encoding: utf-8
class Shop::ProductsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }
  expose(:product) { shop.products.handle!(params[:handle]) }

  def show
    respond_to do |format|
      format.html {
        assign = { 'product' => ProductDrop.new(product) }
        assign['collection'] = CollectionDrop.new(shop.collection(params[:collection_handle])) if params[:collection_handle]
        assign = template_assign(assign.merge('template' => 'product'))
        html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
        render text: html
      }
      format.js {
        product = shop.products.where(handle: params[:handle]).first
        json = product ? product.shop_as_json : {}
        render json: json
      }
    end
  end
end
CollectionsDrop

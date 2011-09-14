#encoding: utf-8
class Shop::CollectionsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }

  def show
    CollectionsDrop
    if params[:handle] == 'all'
      collection = CustomCollection.new(title: '所有商品', products: shop.products)
    else
      collection = shop.custom_collections.find_by_handle(params[:handle]) || shop.smart_collections.find_by_handle(params[:handle])
    end
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page])
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('collection', assign))
    render text: html
  end
end

#encoding: utf-8
class Shop::CollectionsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }

  def index
    path = Rails.root.join 'app/views/shop/collections/collections.liquid'
    collection_view = Liquid::Template.parse(File.read(path)).render('collections' => CollectionsDrop.new(shop) )
    assign = template_assign('content_for_layout' => collection_view)
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('', assign))
    render text: html
  end

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

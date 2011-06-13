#encoding: utf-8
class Shop::CollectionsController < Shop::AppController

  expose(:shop) { Shop.at(request.subdomain) }

  def show
    CollectionsDrop
    collection = CustomCollection.new(title: '所有商品', products: shop.products)
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page])
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('collection', assign))
    render text: html
  end
end

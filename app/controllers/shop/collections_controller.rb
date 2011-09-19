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
      collection = CustomCollection.new(title: '所有商品',handle: 'all', products: shop.products.where(published: true))
    #handle为types时显示商品类型为params[:q]时的商品
    #handle为vendors时显示商品品牌为params[:q]时的商品
    elsif params[:handle] == 'types' || params[:handle] == 'vendors'
      vendor = params[:q]
      column = if params[:handle] == 'types' ; :product_type else :vendor end
      collection = CustomCollection.new(title: params[:q], handle: params[:handle], products: shop.products.where(column => params[:q], published: true))
    else
      collection = shop.custom_collections.where(published: true, handle: params[:handle]).first || shop.smart_collections.where(published: true, handle: params[:handle]).first
    end
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page], 'q' => params[:q])
    #若不存在集合，则显示404页面
    if collection.nil?
      html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('404', assign))
    else
      html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('collection', assign))
    end
    render text: html
  end

end

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
      collection = CustomCollection.new(title: '所有商品', products: shop.products.where(published: true))
    else
      collection = shop.custom_collections.where(published: true, handle: params[:handle]).first || shop.smart_collections.where(published: true, handle: params[:handle]).first
    end
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page])
    #若不存在集合，则显示404页面
    if collection.nil?
      html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('404', assign))
    else
      html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('collection', assign))
    end
    render text: html
  end

  def types
    CollectionsDrop
    type = params[:q]
    collection = CustomCollection.new(title: params[:q], handle: 'types', products: shop.products.where(product_type: params[:q], published: true))
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page])
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('collection', assign))
    render text: html
  end

  def vendors
    CollectionsDrop
    vendor = params[:q]
    collection = CustomCollection.new(title: params[:q], handle: 'vendors', products: shop.products.where(vendor: params[:q], published: true))
    assign = template_assign('collection' => CollectionDrop.new(collection), 'current_page' => params[:page])
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('collection', assign))
    render text: html
  end
end

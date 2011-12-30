#encoding: utf-8
class Shop::CollectionsController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }

  def index # /collections
    path = theme.snippets_path('collection-listing')
    path = Rails.root.join 'app/views/shop/collections/collections.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'list-collections', 'collections' => CollectionsDrop.new(shop))
    collection_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign = assign.merge('content_for_layout' => collection_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  def show # collections/all ...
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
      collection = shop.collection(params[:handle])
    end
    assign = {'collection' => CollectionDrop.new(collection), 'current_page' => params[:page], 'q' => params[:q]}
    if collection.nil? #若不存在集合，则显示404页面
      assign = template_assign(assign.merge('template' => '404'))
      html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    else
      assign = template_assign(assign.merge('template' => 'collection'))
      html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    end
    render text: html
  end

  def show_with_tag # collections/frontpage/手机+带照相功能
    current_tags = params[:tags].split '+'
    collection = shop.collection(params[:handle])
    products = collection.products.select do |product|
      (current_tags & product.tags.map(&:name)) == current_tags # 包含指定的标签(可能为多个)
    end
    collection = CustomCollection.new(title: collection.title, handle: collection.handle, products: products)
    assign = template_assign( 'template' => 'collection', 'collection' => CollectionDrop.new(collection), 'current_page' => params[:page], 'current_tags' => current_tags)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

end

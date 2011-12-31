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

  def show # collections/frontpage
    render text: liquid(assign_for(shop.collection(params[:handle])))
  end

  def show_all # collections/all
    collection = CustomCollection.new(title: '所有商品', handle: 'all', products: shop.products.published)
    render text: liquid(assign_for(collection))
  end

  def show_with_types_or_vendors # collections/types?q=手机  collections/vendors?q=苹果
    column = (params[:handle] == 'types') ?  'product_type' : 'vendor'
    products = shop.products.published.where(column => params[:q])
    if params[:constraint]
      @current_tags = params[:constraint].split '+'
      products = products.select do |product|
        (@current_tags & product.tags.map(&:name)) == @current_tags # 包含指定的标签(可能为多个)
      end
    end
    collection = CustomCollection.new(title: params[:q], handle: params[:handle], products: products)
    render text: liquid(assign_for(collection))
  end

  def show_with_tag # collections/frontpage/手机+带照相功能
    @current_tags = params[:tags].split '+'
    collection = shop.collection(params[:handle])
    products = collection.products.published.select do |product|
      (@current_tags & product.tags.map(&:name)) == @current_tags # 包含指定的标签(可能为多个)
    end
    collection = CustomCollection.new(title: collection.title, handle: collection.handle, products: products)
    render text: liquid(assign_for(collection))
  end

  private
  def assign_for(collection)
    {'template' => 'collection', 'collection' => CollectionDrop.new(collection), 'current_page' => params[:page], 'q' => params[:q], 'current_tags' => @current_tags}
  end

  def liquid(assign)
    Liquid::Template.parse(layout_content).render(shop_assign(template_assign(assign)))
  end

end
CollectionsDrop

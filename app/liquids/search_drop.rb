#encoding: utf-8
class SearchDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(products, terms)
    @products = products
    @terms = terms
  end

  def terms
    @terms
  end

  def performed
    true
  end

  def results
    @product.variants.map do |variant|
      SearchItemDrop.new variant
    end
  end
  memoize :results

end

# 結果Item包括商品、博客、页面
class SearchItemDrop < Liquid::Drop

  def initialize(item)
    @item = item
  end

  def url
    "/products/#{@item.handle}"
  end

  def featured_image
    @item.photos.first
  end

  def title
    @item.title
  end

  def content
    @item.body_html
  end

end

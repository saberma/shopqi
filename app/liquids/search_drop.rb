#encoding: utf-8
class SearchDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(results, terms)
    @results = results
    @terms = terms
  end

  def terms
    @terms
  end

  def performed
    true
  end

  def results
    @results.map do |item|
      SearchItemDrop.new item
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
    "/#{@item.class.table_name}/#{@item.handle}"
  end

  def featured_image
    if @item.respond_to?(:photos)
      @item.photos.first
    end
  end

  def title
    @item.title
  end

  def content
    @item.body_html
  end

end

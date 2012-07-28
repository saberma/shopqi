#encoding: utf-8
class SearchDrop < Liquid::Drop

  def initialize(results, terms)
    @search_results = results || []
    @terms = terms
  end

  def terms
    @terms
  end

  def performed
    !@terms.blank?
  end

  def results
    @results ||= @search_results.map do |item|
      SearchItemDrop.new item
    end
  end

  def results_count
    @search_results.size
  end

end

# 結果Item包括商品、博客、页面
class SearchItemDrop < Liquid::Drop

  def initialize(item)
    @item = item
  end

  def url
    if @item.is_a?(Article)
      blog = @item.blog
      "/#{blog.class.table_name}/#{blog.handle}/#{@item.id}"
    else
      "/#{@item.class.table_name}/#{@item.handle}"
    end
  end

  def featured_image
    if @item.respond_to?(:photos)
      index_photo = @item.photos.first
      ProductImageDrop.new index_photo if index_photo
    end
  end

  def title
    @item.title
  end

  def content
    @item.body_html
  end

end
ProductDrop # 修正开发环境服务启动时访问商店查询页面会报Liquid error: uninitialized constant SearchItemDrop::ProductImageDrop

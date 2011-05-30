class BlogDrop < Liquid::Drop

  def initialize(shop, blog = nil)
    @shop = shop
    @blog = blog
  end
  
  # 关于我们
  define_method('latest-news') do
    self.class.new @shop, @shop.blogs.where(handle: 'latest-new').first
  end

  def articles
    @blog.articles.map do |article|
      ArticleDrop.new article
    end
  end

end

class BlogsDrop < Liquid::Drop

  def initialize(shop)
    @shop = shop
  end

  def before_method(handle) #相当于method_missing
    blog = @shop.blogs.where(handle: handle).first || @shop.blogs.new
    BlogDrop.new blog
  end

end

class BlogDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  delegate :title, :handle, to: :@blog

  def initialize(blog)
    @blog = blog
  end

  def articles
    @blog.articles.map do |article|
      ArticleDrop.new article
    end
  end
  memoize :articles

  def comments_enabled?
    @blog.commentable != 'no'
  end

  def moderated?
    @blog.commentable == "moderate"
  end

end

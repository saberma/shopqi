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
    @blog.comments_enabled?
  end

  def moderated?
    @blog.commentable == "moderate"
  end

  def previous_article
    article = @context['article']
    index = article && article_drops.keys.index(article.id)
    previous_id = index && !index.zero? && article_drops.keys[index-1]
    article_drops[previous_id].url if previous_id
  end

  def next_article
    article = @context['article']
    index = article && article_drops.keys.index(article.id)
    next_id = index && article_drops.keys[index+1]
    article_drops[next_id].url if next_id
  end

  private
  def article_drops # {1 => ArticleDrop.new(article)}
    Hash[ *self.articles.map do |article_drop|
      [article_drop.id, article_drop]
    end.flatten ]
  end
  memoize :article_drops

end

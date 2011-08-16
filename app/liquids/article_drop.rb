class ArticleDrop < Liquid::Drop

  def initialize(article)
    @article = article
  end

  delegate :created_at, :title, :id,  to: :@article

  def content
    @article.body_html.html_safe
  end

  def comments
    @article.comments.map do |comment|
      CommentDrop.new comment
    end
  end

  def url
    "/blogs/#{@article.blog.handle}/#{@article.id}"
  end

  def comments_count
    @article.comments.size
  end

end

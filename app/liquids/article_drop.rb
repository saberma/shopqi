class ArticleDrop < Liquid::Drop

  def initialize(article)
    @article = article
  end

  delegate :created_at, :title, :id,  to: :@article

  def content
    @article.body_html.html_safe
  end

  def comments
    @article.comments.where(:status => 'published').map do |comment|
      CommentDrop.new comment unless comment.new_record?
    end.compact
  end

  def url
    "/blogs/#{@article.blog.handle}/#{@article.id}"
  end

  def comments_count
    comments.size
  end

  def blog
    BlogDrop.new @article.blog
  end

end

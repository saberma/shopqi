class ArticleDrop < Liquid::Drop

  def initialize(article)
    @article = article
  end

  def title
    @article.title
  end

  def content
    @article.body_html.html_safe
  end

end

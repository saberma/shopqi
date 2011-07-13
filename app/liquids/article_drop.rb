class ArticleDrop < Liquid::Drop

  def initialize(article)
    @article = article
  end

  delegate :title,:created_at,:url,:comments_count, to: :@article

  def content
    @article.body_html.html_safe
  end

end

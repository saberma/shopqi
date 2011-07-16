#encoding: utf-8
class Shop::ArticlesController < Shop::AppController
  expose(:shop) { Shop.at(request.subdomain) }
  expose(:blog){ shop.blogs.where(handle: params[:handle]).first }
  expose(:articles){ blog.articles }
  expose(:article){ Article.find(params[:article_id] || params[:id])}
  expose(:comment)
  def show
    BlogsDrop
    assign = template_assign('article' => ArticleDrop.new(article), 'blog' => BlogDrop.new(blog), 'comment' => article.comments.new)
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('article', assign))
    render text: html
  end

  def add_comment
    if comment.save
      redirect_to "/blogs/#{article.blog.handle}/#{article.id}"
    else
    end
  end
end

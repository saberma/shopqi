#encoding: utf-8
class Shop::ArticlesController < Shop::AppController
  expose(:shop) { Shop.at(request.subdomain) }
  expose(:blog){ shop.blogs.where(handle: params[:handle]).first }
  expose(:articles){ blog.articles }
  expose(:article)
  def show
    BlogsDrop
    assign = template_assign('article' => ArticleDrop.new(article), 'blog' => BlogDrop.new(blog))
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('article', assign))
    render text: html
  end
end

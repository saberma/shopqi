#encoding: utf-8
class Shop::BlogsController < Shop::AppController
  expose(:shop) { Shop.at(request.host) }
  expose(:blog){ shop.blogs.where(handle: params[:handle]).first }
  expose(:articles){ blog.articles }

  def show
    BlogsDrop
    assign = template_assign('blog' => BlogDrop.new(blog))
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('blog', assign))
    render text: html
  end

end

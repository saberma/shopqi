#encoding: utf-8
class Shop::PagesController < Shop::AppController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }

  expose(:page) { shop.pages.where(handle: params[:handle]).first }

  def show
    PagesDrop
    assign = template_assign('page' => PageDrop.new(page))
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('page', assign))
    render text: html
  end
end

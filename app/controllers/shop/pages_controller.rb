#encoding: utf-8
class Shop::PagesController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }

  expose(:page) { shop.pages.published_handle!(params[:handle]) }

  def show
    PagesDrop
    assign = template_assign('template' => 'page', 'page' => PageDrop.new(page))
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end
end

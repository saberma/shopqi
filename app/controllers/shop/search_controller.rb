#encoding: utf-8
class Shop::SearchController < Shop::AppController

  expose(:shop) { Shop.at(request.subdomain) }

  expose(:products) { shop.products.search(params[:q]) }

  def show
    PagesDrop
    assign = template_assign('search' => PageDrop.new(page))
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('page', assign))
    render text: html
  end
end

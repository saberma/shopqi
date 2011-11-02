#encoding: utf-8
class Shop::SearchController < Shop::AppController

  expose(:shop) { Shop.at(request.host) }

  expose(:results) do
    if params[:q].blank?
      nil
    else
      Sunspot.search(Product, Article, Page) do
        keywords params[:q]
        with :shop_id, shop.id
      end.results
    end
  end

  def show
    assign = template_assign('search' => SearchDrop.new(results, params[:q]), 'q' => params[:q])
    html = Liquid::Template.parse(layout_content).render(shop_assign('search', assign))
    render text: html
  end
end

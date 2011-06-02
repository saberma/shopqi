#encoding: utf-8
class Shop::ProductsController < ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }
  expose(:product) { shop.products.where(handle: params[:handle]).first }

  def show
    template = 'product'
    shop_drop = ShopDrop.new(shop)
    settings_drop = SettingsDrop.new(shop)
    linklists_drop = LinkListsDrop.new(shop)
    collection_drop = CollectionsDrop.new(shop)
    pages_drop = PagesDrop.new(shop)
    product_drop = ProductDrop.new(product)
    powered_by_link = "<a href='http://www.shopqi.com' target='_blank' title='应用ShopQi电子商务平台创建您的网上商店'>powered by ShopQi电子商务平台</a>"
    template_assign = {
      'shop' => shop_drop,
      'product' => product_drop
    }
    content_for_layout = Liquid::Template.parse(File.read(shop.theme.template_path(template))).render(template_assign)
    assign = {
      'shop' => shop_drop,
      'settings' => settings_drop,
      'template' => template,
      'linklists' => linklists_drop,
      'pages' => pages_drop,
      'collections' => collection_drop,
      'content_for_header' => '',
      'content_for_layout' => content_for_layout,
      'powered_by_link' => powered_by_link
    }
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(assign)
    render text: html
  end
end

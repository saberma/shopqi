# encoding: utf-8
class Shop::ApplicationController < ActionController::Base
  protect_from_forgery

  def shop_assign(template = 'index', template_object = nil)
    shop_drop = ShopDrop.new(shop)
    settings_drop = SettingsDrop.new(shop)
    linklists_drop = LinkListsDrop.new(shop)
    collections_drop = CollectionsDrop.new(shop)
    pages_drop = PagesDrop.new(shop)
    powered_by_link = "<a href='http://www.shopqi.com' target='_blank' title='应用ShopQi电子商务平台创建您的网上商店'>powered by ShopQi电子商务平台</a>"
    content_for_layout = Liquid::Template.parse(File.read(shop.theme.template_path(template))).render(template_assign(template_object))
    {
      'shop' => shop_drop,
      'settings' => settings_drop,
      'template' => template,
      'linklists' => linklists_drop,
      'pages' => pages_drop,
      'collections' => collections_drop,
      'content_for_header' => '',
      'content_for_layout' => content_for_layout,
      'powered_by_link' => powered_by_link
    }
  end

  def asset_assign
    {
      'shop' => ShopDrop.new(shop),
      'settings' => SettingsDrop.new(shop),
    }
  end

  def template_assign(product = nil)
    shop_drop = ShopDrop.new(shop)
    product_drop = ProductDrop.new(product)
    collections_drop = CollectionsDrop.new(shop)
    {
      'shop' => shop_drop,
      'collections' => collections_drop,
      'product' => product_drop
    }
  end

end

# encoding: utf-8
class Shop::ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  begin 'liquid'

    # 渲染layout时的hash
    def shop_assign(template = 'index', template_extra_object = {})
      shop_drop = ShopDrop.new(shop)
      settings_drop = SettingsDrop.new(shop)
      linklists_drop = LinkListsDrop.new(shop)
      collections_drop = CollectionsDrop.new(shop)
      pages_drop = PagesDrop.new(shop)
      powered_by_link = "<a href='http://www.shopqi.com' target='_blank' title='应用ShopQi电子商务平台创建您的网上商店'>Powered by ShopQi电子商务平台</a>"
      content_for_layout = Liquid::Template.parse(File.read(shop.theme.template_path(template))).render(template_assign(template_extra_object))
      {
        'shop' => shop_drop,
        'cart' => cart_drop,
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

    # 渲染附件asset时的hash
    def asset_assign
      {
        'shop' => ShopDrop.new(shop),
        'settings' => SettingsDrop.new(shop),
      }
    end

    # 渲染template时的hash
    def template_assign(extra_assign)
      shop_drop = ShopDrop.new(shop)
      collections_drop = CollectionsDrop.new(shop)
      {
        'shop' => shop_drop,
        'collections' => collections_drop,
      }.merge(extra_assign)
    end

    def cart_drop
      CartDrop.new(cookie_cart_hash)
    end

  end

  begin 'cart'

    def cookie_cart_hash
      cookies['cart'] = '' if cookies['cart'].nil?
      # 格式: variant_id|quantity;variant_id|quantity
      cart = cookies['cart'].split(';').map {|item| item.split('|')}
      Hash[*cart.flatten]
    end

    def save_cookie_cart(cart_hash)
      cart_hash.delete_if {|key, value| value.zero?}
      cookies['cart'] = cart_hash.to_a.map{|item| item.join('|')}.join(';')
    end

  end

end

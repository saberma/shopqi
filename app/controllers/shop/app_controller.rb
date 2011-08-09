# encoding: utf-8
class Shop::AppController < ActionController::Base
  layout nil #默认不需要layout，使用liquid
  before_filter :force_domain # 域名管理中是否设置主域名重定向

  #protect_from_forgery #theme各个页面中的form都没有csrf，导致post action获取不到session id

  protected
  def force_domain
    host = request.host
    primary = Shop.at(host).primary_domain
    if primary.force_domain and host != primary.host  # 重定向
      redirect_to "#{request.protocol}#{primary.host}#{request.port_string}#{request.path}"
    end
  end

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
      settings_drop = SettingsDrop.new(shop)
      linklists_drop = LinkListsDrop.new(shop)
      collections_drop = CollectionsDrop.new(shop)
      {
        'shop' => shop_drop,
        'settings' => settings_drop,
        'linklists' => linklists_drop,
        'collections' => collections_drop
      }.merge(extra_assign)
    end

    def cart_drop
      CartDrop.new(cookie_cart_hash)
    end

  end

  begin 'cart'

    def cookie_cart_hash
      session['cart'] = '' if session['cart'].nil?
      # 格式: variant_id|quantity;variant_id|quantity
      cart = session['cart'].split(';').map {|item| item.split('|')}
      Hash[*cart.flatten]
    end

    def save_cookie_cart(cart_hash)
      cart_hash.delete_if {|key, value| value.to_i.zero?}
      session['cart'] = cart_hash.to_a.map{|item| item.join('|')}.join(';')
    end

  end

end


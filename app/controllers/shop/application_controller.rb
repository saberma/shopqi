# encoding: utf-8
class Shop::ApplicationController < ActionController::Base
  #protect_from_forgery #theme各个页面中的form都没有csrf，导致post action获取不到session id

  # 顾客创建订单时的页面显示的错误提示
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    unless html_tag =~ /^<label/
      %{<div class="field-with-errors"><span class="error-message">#{instance.error_message.first}</span><br/>#{html_tag}</div>}.html_safe
    else
      html_tag.html_safe
    end
  end

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

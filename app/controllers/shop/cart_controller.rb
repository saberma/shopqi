#encoding: utf-8
class Shop::CartController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }

  def add
    cookies['cart'] = '' if cookies['cart'].nil?
    # 格式: variant_id|quantity;variant_id|quantity
    cart = cookies['cart'].split(';').map {|item| item.split('|')}
    cart_hash = Hash[*cart.flatten]
    cart_hash[params[:id]] = cart_hash[params[:id]].to_i + params[:quantity].to_i
    cookies['cart'] = cart_hash.to_a.map{|item| item.join('|')}.join(';')
    redirect_to cart_path
  end

  def show
    template_assign = { 'cart' => cart_drop }
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('cart', template_assign))
    render text: html
  end
end

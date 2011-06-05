#encoding: utf-8
class Shop::CartController < Shop::ApplicationController
  layout nil

  expose(:shop) { Shop.at(request.subdomain) }

  def add
    cart_hash = cookie_cart_hash
    cart_hash[params[:id]] = cart_hash[params[:id]].to_i + 1
    save_cookie_cart(cart_hash)
    redirect_to cart_path
  end

  def show
    template_assign = { 'cart' => cart_drop }
    html = Liquid::Template.parse(File.read(shop.theme.layout_theme_path)).render(shop_assign('cart', template_assign))
    render text: html
  end

  def update
    cart_hash = cookie_cart_hash
    params[:updates].each_pair do |variant_id, quantity|
      cart_hash[variant_id] = quantity.to_i
    end
    save_cookie_cart(cart_hash)
    if params[:checkout].blank?
      redirect_to cart_path
    else
      checkout_url = "#{request.protocol}checkout.#{request.domain}#{request.port_string}/carts/#{shop.id}"
      redirect_to checkout_url
    end
  end

  # 订单提交
  def new
    @shop = Shop.find(params[:shop_id])
  end

  def create
  end

  private
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

#encoding: utf-8
class Shop::CartController < Shop::AppController
  include Admin::ShopsHelper

  expose(:shop) { Shop.at(request.host) }

  def add
    cart_hash = cookie_cart_hash
    cart_hash[params[:id]] = cart_hash[params[:id]].to_i + 1
    save_cookie_cart(cart_hash)
    redirect_to cart_path
  end

  def show
    cart_hash = cookie_cart_hash
    template_assign = { 'cart' => cart_drop }
    html = Liquid::Template.parse(File.read(theme.layout_theme_path)).render(shop_assign('cart', template_assign))
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
      cart = shop.carts.find_or_create({session_id: request.session_options[:id]}, cart_hash: cart_hash.to_json)
      if shop.customer_accounts_required?
        Devise::FailureApp.default_url_options = { host: "#{shop.primary_domain.host}#{request.port_string}",  checkout_url: "#{checkout_url_with_port}/carts/#{cart.shop_id}/#{cart.token}"}
        self.send :authenticate_customer!
        cart.customer = current_customer
        cart.save
      end
      checkout_url = "#{checkout_url_with_port}/carts/#{shop.id}/#{cart.token}"
      redirect_to checkout_url
    end
  end

end

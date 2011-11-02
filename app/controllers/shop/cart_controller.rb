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
    html = Liquid::Template.parse(layout_content).render(shop_assign('cart', template_assign))
    render text: html
  end

  def update
    cart_hash = cookie_cart_hash
    updates = params[:updates] # 款式数量
    if updates.is_a? Hash # 支持两种参数格式
      updates.each_pair do |variant_id, quantity|
        cart_hash[variant_id] = quantity.to_i
      end
    elsif updates.is_a? Array
      updates.each_with_index do |quantity, index|
        variant_id = cart_hash.keys[index]
        cart_hash[variant_id] = quantity.to_i
      end
    end
    save_cookie_cart(cart_hash)
    if params[:checkout].blank? and params['checkout.x'].blank? # 支持按钮提交和图片提交两种方式
      redirect_to cart_path
    else
      cart = shop.carts.update_or_create({session_id: request.session_options[:id]}, cart_hash: cart_hash.to_json)
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

  def change # 修改某个款式的购买数量 quantity=0 时移除
    cart_hash = cookie_cart_hash
    cart_hash[params[:variant_id]] = params[:quantity].to_i
    save_cookie_cart(cart_hash)
    redirect_to cart_path
  end

end

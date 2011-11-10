#encoding: utf-8
class Shop::CartController < Shop::AppController
  include Admin::ShopsHelper

  expose(:shop) { Shop.at(request.host) }

  def add
    id = params[:id] # variant.id
    quantity = params[:quantity] ? params[:quantity].to_i : 1
    quantity = get_line_item(id).to_i + quantity
    save_line_item id, quantity
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js   {
        SessionCart # SessionLineItem类所在文件
        render json: SessionLineItem.new(id, quantity, shop)
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        html = Liquid::Template.parse(layout_content).render(shop_assign('cart', template_assign))
        render text: html
      }
      format.js { render json: SessionCart.new(session_cart_hash, shop) }
    end
  end

  def update
    cart_hash = session_cart_hash
    updates = params[:updates] # 款式数量
    if updates.is_a? Hash # 支持两种参数格式
      updates.each_pair do |variant_id, quantity|
        save_line_item variant_id, quantity.to_i
      end
    elsif updates.is_a? Array
      updates.each_with_index do |quantity, index|
        variant_id = cart_hash.keys[index]
        cart_hash[variant_id] = quantity.to_i
      end
    end
    if params[:checkout].blank? and params['checkout.x'].blank? # 支持按钮提交和图片提交两种方式
      redirect_to cart_path
    else
      cart = shop.carts.update_or_create({session_id: session_id}, cart_hash: cart_hash.to_json)
      checkout_url = "#{checkout_url_with_port}/carts/#{shop.id}/#{cart.token}"
      if shop.customer_accounts_required?
        session['customer_return_to'] = checkout_url
        self.send :authenticate_customer!
        cart.customer = current_customer
        cart.save
      end
      redirect_to checkout_url
    end
  end

  def change # 修改某个款式的购买数量 quantity=0 时移除
    id = params[:variant_id] || params[:id]
    save_line_item id, params[:quantity].to_i
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js   { render json: SessionCart.new(session_cart_hash, shop) }
    end
  end

  def clear # 清空购物车
    clear_cart
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js   { render json: SessionCart.new({}, shop) }
    end
  end

  private
  def save_line_item(variant_id, quantity)
    if quantity.zero?
      Resque.redis.hdel cart_key, variant_id
    else
      Resque.redis.hset cart_key, variant_id, quantity
    end
  end

  def get_line_item(variant_id)
    Resque.redis.hget(cart_key, variant_id) || 0
  end

  def clear_cart
    Resque.redis.del cart_key
  end

end

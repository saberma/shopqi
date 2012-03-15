module Shop::OrderHelper
  def checkout_url(cart = nil)
    if cart
      "/carts/#{cart.token}"
    else
      session['customer_return_to'] || params['checkout_url'] # 1. 顾客结算时未跳转至checkout子域名，使用session；2. 否则发现cart未关联顾客时，使用checkout_url参数
    end
  end
end

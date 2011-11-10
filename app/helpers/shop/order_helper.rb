module Shop::OrderHelper
  def checkout_url(cart = nil)
    if cart
      "#{request.protocol}checkout.#{Setting.host}#{request.port_string}/carts/#{cart.shop_id}/#{cart.token}"
    else
      # 与app/controllers/shop/sessions_controller.rb保持一致，在顾客登录页面中使用
      session['customer_return_to'] || params['checkout_url']
    end
  end
end

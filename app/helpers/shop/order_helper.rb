module Shop::OrderHelper
  def checkout_url(cart)
    "#{request.protocol}checkout.#{Setting.host}#{request.port_string}/carts/#{cart.shop_id}/#{cart.token}"
  end
end

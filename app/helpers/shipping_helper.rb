#encoding: utf-8
module ShippingHelper
  def price_max_order_subtotal_helper(price_based_shipping_rate)
    if price_based_shipping_rate.max_order_subtotal.nil?
      "最少"
    else
      " - ¥#{price_based_shipping_rate.max_order_subtotal}"
    end
  end
end

class Admin::ShippingController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:weight_based_shipping_rates) { shop.weight_based_shipping_rates }
  expose(:weight_based_shipping_rates_json) { weight_based_shipping_rates.to_json(except: [ :created_at, :updated_at ]) }
  expose(:price_based_shipping_rates) { shop.price_based_shipping_rates }
  expose(:price_based_shipping_rates_json) { price_based_shipping_rates.to_json(except: [ :created_at, :updated_at ]) }
end

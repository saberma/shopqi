class ShippingController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:countries){ shop.countries }
  expose(:country)
  expose(:weight_based_shipping_rates)
  expose(:weight_based_shipping_rate)

  def set_weight_based_price
    weight_based_shipping_rate.save
    flash[:notice] = notice_msg
  end

end

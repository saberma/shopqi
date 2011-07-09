class WeightBasedShippingRatesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:weight_based_shipping_rate)
  expose(:country){ weight_based_shipping_rate.country }

  def create
    weight_based_shipping_rate.save
    flash[:notice] = notice_msg
  end
end

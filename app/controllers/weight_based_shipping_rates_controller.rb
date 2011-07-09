class WeightBasedShippingRatesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:weight_based_shipping_rate)
  expose(:country){ weight_based_shipping_rate.country }

  def create
    weight_based_shipping_rate.save
    flash.now[:notice] = notice_msg
  end

  def destroy
    weight_based_shipping_rate.destroy
    flash.now[:notice] = notice_msg
  end
end

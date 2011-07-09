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

  def update
    weight_based_shipping_rate.save
    redirect_to edit_weight_based_shipping_rate_path(weight_based_shipping_rate),notice: notice_msg
  end
end

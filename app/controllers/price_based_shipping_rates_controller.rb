class PriceBasedShippingRatesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:price_based_shipping_rate)
  expose(:country){ price_based_shipping_rate.country }

  def create
    price_based_shipping_rate.save
    flash.now[:notice] = notice_msg
  end

  def destroy
    price_based_shipping_rate.destroy
    flash.now[:notice] = notice_msg
  end

  def update
    price_based_shipping_rate.save
    redirect_to edit_price_based_shipping_rate_path(price_based_shipping_rate),notice: notice_msg
  end
end

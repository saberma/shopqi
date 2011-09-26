class PriceBasedShippingRatesController < AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:price_based_shipping_rate)
  expose(:country){ price_based_shipping_rate.country }

  def create
    if price_based_shipping_rate.save
      flash.now[:notice] = notice_msg
    else
      flash[:error] = price_based_shipping_rate.errors.full_messages[0]
      render template: "shared/error_msg"
    end
  end

  def destroy
    price_based_shipping_rate.destroy
    flash.now[:notice] = notice_msg
  end

  def update
    if price_based_shipping_rate.save
      redirect_to edit_price_based_shipping_rate_path(price_based_shipping_rate),notice: notice_msg
    else
      render action: 'edit'
    end
  end
end

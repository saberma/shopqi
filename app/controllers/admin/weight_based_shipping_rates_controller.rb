class Admin::WeightBasedShippingRatesController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:shippings) { shop.shippings }
  expose(:shipping)
  expose(:weight_based_shipping_rates) { shipping.weight_based_shipping_rates }
  expose(:weight_based_shipping_rate)

  def create
    weight_based_shipping_rate.save
    render json: weight_based_shipping_rate
  end

  def destroy
    weight_based_shipping_rate.destroy
    render json: weight_based_shipping_rate
  end

  def update
    if weight_based_shipping_rate.save
      redirect_to edit_shipping_weight_based_shipping_rate_path(shipping, weight_based_shipping_rate),notice: notice_msg
    else
      render action: 'edit'
    end
  end
end

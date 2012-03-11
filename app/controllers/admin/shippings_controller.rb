class Admin::ShippingsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:shippings) { shop.shippings }
  expose(:shipping)
  expose(:shippings_json) do
    shippings.to_json(
      except: [ :created_at, :updated_at ],
      include: [:weight_based_shipping_rates, :price_based_shipping_rates]
    )
  end
  #expose(:weight_based_shipping_rates) { shop.weight_based_shipping_rates }
  #expose(:weight_based_shipping_rates_json) { weight_based_shipping_rates.to_json(except: [ :created_at, :updated_at ]) }
  #expose(:price_based_shipping_rates) { shop.price_based_shipping_rates }
  #expose(:price_based_shipping_rates_json) { price_based_shipping_rates.to_json(except: [ :created_at, :updated_at ]) }

  def create
    shipping.save
    render json: shipping
  end

  def destroy
    shipping.destroy
    render json: shipping
  end
end

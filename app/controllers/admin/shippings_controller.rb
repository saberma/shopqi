class Admin::ShippingsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:shippings) { shop.shippings }
  expose(:shipping)
  expose(:json_options) do
    {
      methods: :code_name,
      except: [ :created_at, :updated_at ],
      include: [:weight_based_shipping_rates, :price_based_shipping_rates]
    }
  end
  expose(:shippings_json) { shippings.to_json(json_options) }
  expose(:shipping_json) { shipping.to_json(json_options) }

  def create
    shipping.save
    render json: shipping_json
  end

  def destroy
    shipping.destroy
    render json: shipping
  end
end

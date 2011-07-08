class Country < ActiveRecord::Base
  belongs_to :shop
  has_many :weight_based_shipping_rates,          dependent: :destroy
  default_value_for :tax_percentage, 0.0
end

class WeightBasedShippingRate < ActiveRecord::Base
  belongs_to :country
  default_value_for :weight_low , 0.0
  default_value_for :weight_high, 25.0
  default_value_for :price, 10.0
end

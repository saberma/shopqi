class Country < ActiveRecord::Base
  belongs_to :shop
  has_many :weight_based_shipping_rates,          dependent: :destroy
  has_many :price_based_shipping_rates ,          dependent: :destroy
  default_value_for :tax_percentage, 0.0
end

class WeightBasedShippingRate < ActiveRecord::Base
  belongs_to :country
  default_value_for :weight_low , 0.0
  default_value_for :weight_high, 25.0
  default_value_for :price, 10.0
  validates_presence_of :name
end

class PriceBasedShippingRate < ActiveRecord::Base
  belongs_to :country
  default_value_for :min_order_subtotal , 50.0
  default_value_for :price, 0.0
  validates_presence_of :name
end

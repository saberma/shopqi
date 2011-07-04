class Country < ActiveRecord::Base
  belongs_to :shop

  default_value_for :tax_percentage, 0.0
end

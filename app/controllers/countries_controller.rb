class CountriesController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:countries){ shop.countries }
  expose(:country)

end

class Shop::AddressesController < ApplicationController
  prepend_before_filter :authenticate_customer!
  layout 'shop/admin'

  expose(:shop){ current_customer.shop }
  expose(:addresses){ current_customer.addresses }
  expose(:address)
  expose(:countries){ shop.countries }

  def create
    address.save
  end

end

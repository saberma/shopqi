class Shop::AddressesController < ApplicationController
  prepend_before_filter :authenticate_customer!
  layout 'shop/admin'

  expose(:addresses){ current_customer.addresses }
end

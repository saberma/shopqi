class Shop::AddressesController < ApplicationController
  prepend_before_filter :authenticate_customer!
  layout 'shop/admin'
end

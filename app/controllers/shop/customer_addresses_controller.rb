class Shop::CustomerAddressesController < ApplicationController
  prepend_before_filter :authenticate_customer!
  layout 'shop/admin'

  expose(:customer_addresses){
    current_customer.addresses
  }
  expose(:customer_address)
  expose(:shop){ current_customer.shop }
  expose(:countries){ shop.countries }

  def create
    if params[:customer_address][:default_address] == '1'
      customer_addresses.update_all default_address: false
    end
    customer_address.save
    redirect_to customer_addresses_path
  end

  def update
    if params[:customer_address][:default_address] == '1'
      customer_addresses.update_all default_address: false
    end
    customer_address.save
    redirect_to customer_addresses_path
  end

  def destroy
    customer_address.destroy
    render js: "$('#address_table_#{customer_address.id}').remove();"
  end

end

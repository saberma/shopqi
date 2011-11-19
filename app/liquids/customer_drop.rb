#encoding: utf-8
#订单关联的liquid属性
class CustomerDrop < Liquid::Drop

  def initialize(customer)
    @customer = customer
  end

  delegate :email, :name,:reset_password_token, to: :@customer

  def default_address
    address =  @customer.addresses.where(default_address: true).first ||  @customer.addresses.first
    CustomerAddressDrop.new address if address
  end

  def addresses_count
    @customer.addresses.size
  end

  def first_name
    @customer.name
  end

  def orders
    @customer.orders.map do |order|
      OrderDrop.new  order
    end
  end

  def errors
    #@customer.errors.messages.stringify_keys if @customer.errors
    @customer.errors.full_messages if @customer.errors
  end

end

class CustomerAddressDrop < Liquid::Drop

  def initialize(address)
    @address = address
  end

  delegate :zip, :phone, :address1, :address2, to: :@address

  def country
    @address.country_name
  end

  def province_code
    @address.province_name
  end

  def city
    @address.city_name
  end

  def district
    @address.district_name
  end

end

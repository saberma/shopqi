#encoding: utf-8
#订单关联的liquid属性
class CustomerDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

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

  def addresses
    @customer.addresses.map do |address|
      CustomerAddressDrop.new address if address.id?
    end.compact
  end
  memoize :addresses

  def orders
    @customer.orders.map do |order|
      OrderDrop.new  order
    end
  end
  memoize :orders

  def new_address
    CustomerAddressDrop.new @customer.addresses.new
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

  delegate :id,:name,:company,:zip, :phone, :address1, :address2,:detail_address,:default_address, to: :@address

  def country # 不显示国籍
    ''
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

  def set_as_default_checkbox
    checked = @address.default_address ? "checked" : ""
    %Q{<input name="address[default_address]" type="hidden" value="0">
      <input type="checkbox" id="address_default_address_#{@address.id}" name="address[default_address]" value="1" #{checked} >
    }
  end

  def province_option_tags
    @address.province_option_tags
  end

  def city_option_tags
    @address.city_option_tags
  end

  def district_option_tags
    @address.district_option_tags
  end

end

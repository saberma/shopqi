# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_many :orders
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress'

  accepts_nested_attributes_for :addresses

  default_value_for :status, 'enabled'

  def available_orders # 有效订单
    self.orders.where(financial_status: [:paid, :pending, :authorized])
  end

  # 默认地址
  def address
    json = addresses.first.as_json(methods: [:province_name, :city_name, :district_name])
    json['customer_address']
  end

  # 首次下单
  def order
    self.available_orders.first.as_json['order']
  end

  def status_name
    KeyValues::Customer::State.find_by_code(status).name
  end

  # 加入地址(不能重复)
  def add_address(a) #a可以是billing_address或者shipping_address
    attrs = { name: a.name, company: a.company, country: a.country, province: a.province, city: a.city,
              district: a.district, address1: a.address1, address2: a.address2, zip: a.zip, phone: a.phone }
    unless self.addresses.exists?(attrs)
      self.addresses.create attrs
    end
  end
end

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer

  def province_name
    District.get(self.province)
  end

  def city_name
    District.get(self.city)
  end

  def district_name
    District.get(self.district)
  end
end

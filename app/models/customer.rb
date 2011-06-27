# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_many :orders
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress'

  accepts_nested_attributes_for :addresses

  default_value_for :status, 'enabled'

  # 默认地址
  def address
    json = addresses.first.as_json(methods: [:province_name, :city_name, :district_name])
    json['customer_address']
  end

  # 首次下单
  def order
    self.orders.where(status: [:paid, :pending, :authorized]).first.as_json['order']
  end

  def status_name
    KeyValues::Customer::State.find_by_code(status).name
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

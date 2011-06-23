# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_many :orders
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress'

  accepts_nested_attributes_for :addresses
end

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer
end

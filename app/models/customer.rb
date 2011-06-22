# encoding: utf-8
class Customer < ActiveRecord::Base
  belongs_to :shop
  has_one :addresses, dependent: :destroy, class_name: 'CustomerAddress'
end

class CustomerAddress < ActiveRecord::Base
  belongs_to :customer
end

class CustomerGroup < ActiveRecord::Base
  belongs_to :shop
end

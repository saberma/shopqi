#encoding: utf-8
class Order < ActiveRecord::Base
  set_primary_key :uuid
  belongs_to :shop
  has_one :billing_address , dependent: :destroy, class_name: 'OrderBillingAddress' , foreign_key: :order_uuid
  has_one :shipping_address, dependent: :destroy, class_name: 'OrderShippingAddress', foreign_key: :order_uuid
  has_many :variants       , dependent: :destroy, class_name: 'OrderProductVariant' , foreign_key: :order_uuid

  attr_protected :total_price #总金额只能通过商品价格计算而来，不能从页面传递

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates_associated :billing_address
  validates_presence_of :email, :billing_address, message: '此栏不能为空白'
  validates_presence_of :shipping_rate, :gateway, on: :update

  before_create do
    self.uuid = UUID.generate(:compact)
    self.total_price = self.variants.map(&:price).sum
  end

end

# 订单商品
class OrderProductVariant < ActiveRecord::Base
  belongs_to :order
  belongs_to :product_variant
  validates_presence_of :price, :quantity
end

# 发单人信息
class OrderBillingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  before_create do
    self.country = 'china'
  end
end

# 收货人信息
class OrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :name, :province, :city, :district, :address1, :phone, message: '此栏不能为空白'

  before_create do
    self.country = 'china'
  end
end

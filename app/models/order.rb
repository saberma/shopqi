#encoding: utf-8
class Order < ActiveRecord::Base
  belongs_to :shop
  has_one :billing_address , class_name: 'OrderBillingAddress'
  has_one :shipping_address, class_name: 'OrderShippingAddress'

  attr_protected :total_price

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates_associated :billing_address
  validates_presence_of :email, :billing_address, if: :first_step?, message: '此栏不能为空白'
  validates_presence_of :shipping_rate, :gateway, if: :last_step?, message: '此栏不能为空白'

  attr_writer :current_step

  before_create do
    self.total_price = 0 #TODO: calculate from products
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  begin 'steps'

    def steps
      %w[address pay]
    end

    def current_step
      @current_step || steps.first
    end

    def first_step?
      self.current_step == steps.first
    end

    def last_step?
      self.current_step == steps.last
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

  end

end

# 订单商品
class OrderProducts < ActiveRecord::Base
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

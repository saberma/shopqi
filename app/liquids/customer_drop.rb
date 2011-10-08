#encoding: utf-8
#订单关联的liquid属性
class CustomerDrop < Liquid::Drop
  def initialize(customer)
    @customer = customer
  end
  delegate :email,:name, to: :@customer
end

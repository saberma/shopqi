# encoding: utf-8
class OrderObserver < ActiveRecord::Observer

  def before_save(order)
    # 保存顾客信息
    shop = order.shop
    customer = shop.customers.where(email: order.email).first
    address = order.shipping_address
    unless customer
      name = address ? address.name : '虚拟商品用户'
      customer = shop.customers.create email: order.email, name: name, password: Random.new.rand(100000..999999)
    end
    customer.add_address address if address
    order.customer = customer
  end

end

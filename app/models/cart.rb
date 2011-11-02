#encoding: utf-8
# 购物车
class Cart < ActiveRecord::Base
  belongs_to :shop
  belongs_to :customer

  before_create do
    self.token = UUID.generate(:compact)
  end

  def self.update_or_create(condition, attrs)
    cart = where(condition).first
    if cart
      cart.update_attributes attrs
    else
      cart = create(attrs.merge(condition))
    end
    cart
  end
end

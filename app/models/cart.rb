#encoding: utf-8
# 购物车
class Cart < ActiveRecord::Base
  belongs_to :shop
  belongs_to :customer

  before_create do
    self.token = UUID.generate(:compact)
  end

  before_destroy do # 清空浏览器session购物车
    Resque.redis.del self.class.key(self.shop, self.session_id)
  end

  def self.key(shop, session_id)
    "cart_#{shop.id}_#{session_id}"
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

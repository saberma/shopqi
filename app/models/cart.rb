#encoding: utf-8
# 购物车
class Cart < ActiveRecord::Base
  set_primary_key :uuid

  belongs_to :shop

  before_create do
    self.uuid = UUID.generate(:compact)
  end

  def self.find_or_create(condition, attrs)
    where(condition).first || create(attrs.merge(condition))
  end
end

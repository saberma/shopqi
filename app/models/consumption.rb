class Consumption < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :shop
  belongs_to_active_hash :plan_type,  class_name: 'KeyValues::Plan::Type'

  attr_protected :price, :status

  default_value_for(:token){ UUID.generate(:compact) }
  default_value_for :quantity, 1
  default_value_for :status, false

  before_create do
    self.price = self.plan_type.price
  end

  def pay!
    self.status = true
    self.save
    base = shop.deadline.future? ? shop.deadline : Date.today
    shop.deadline = base.advance(months: self.quantity)
    shop.plan = self.plan_type.code
    shop.save
  end

  def total_price
    self.quantity * self.price
  end

end

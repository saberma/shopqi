class Consumption < ActiveRecord::Base
  belongs_to :shop
  default_value_for(:token){ UUID.generate(:compact) }
  default_value_for :quantity, 1
  default_value_for :status, false
  belongs_to :plan_type,  class_name: 'KeyValues::Plan::Type'

  def pay!
    self.update_attributes status: true
    base = shop.deadline.future? ? shop.deadline : Date.today
    deadline = base + 30 * self.quantity
    shop.update_attributes deadline: deadline, plan: self.plan_type.code
  end

end

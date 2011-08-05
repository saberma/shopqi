class Consumption < ActiveRecord::Base
  belongs_to :shop
  default_value_for(:token){ UUID.generate(:compact) }
  default_value_for :quantity, 1
  default_value_for :status, false

  def pay!
    self.update_attributes status: true
    base = shop.current_plan.deadline.future? ? shop.deadline : Date.today
    deadline = base + 30 * self.quantity
    shop.plans.update_all status: false
    Plan.create shop: self.shop, plan_type_id: self.plan_type_id, deadline: deadline
  end

end

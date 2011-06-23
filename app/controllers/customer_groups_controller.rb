#encoding: utf-8
class CustomerGroupsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:customer_groups) { shop.customer_groups }
  expose(:customer_groups_json) do
    customer_groups.to_json({
      except: [ :created_at, :updated_at ]
    })
  end
end

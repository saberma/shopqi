#encoding: utf-8
class Admin::CustomerGroupsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:customer_groups) { shop.customer_groups }
  expose(:customer_group)
  expose(:customer_groups_json) do
    customer_groups.to_json({
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:customer_group_json) do
    customer_group.to_json({
      except: [ :created_at, :updated_at ]
    })
  end

  def create
    customer_group.save
    render json: customer_group_json
  end

  def update
    customer_group.save
    render json: customer_group_json
  end

  def destroy
    customer_group.destroy
    render json: customer_group_json
  end
end

#encoding: utf-8
class OrdersController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:orders) do
    if params[:search]
      shop.orders.metasearch(params[:search]).all
    else
      shop.orders
    end
  end
  expose(:order)
  expose(:orders_json) do
    orders.to_json({
      except: [ :updated_at ]
    })
  end
  expose(:status) { KeyValues::Order::Status.all }
  expose(:financial_status) { KeyValues::Order::FinancialStatus.all }
  expose(:fulfillment_status) { KeyValues::Order::FulfillmentStatus.all }
  expose(:page_sizes) { KeyValues::PageSize.all }
end

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
      methods: [ :status_name, :financial_status_name, :fulfillment_status_name ],
      except: [ :updated_at ]
    })
  end
  expose(:status) { KeyValues::Order::Status.hash }
  expose(:financial_status) { KeyValues::Order::FinancialStatus.hash }
  expose(:fulfillment_status) { KeyValues::Order::FulfillmentStatus.hash }
  expose(:page_sizes) { KeyValues::PageSize.hash }
end

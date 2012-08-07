object @order
attributes :id, :name, :note, :number, :subtotal_price, :token, :total_line_items_price, :total_price, :total_weight, :order_number, :financial_status, :financial_status_name, :fulfillment_status, :fulfillment_status_name, :cancel_reason, :cancelled_at, :created_at, :updated_at

child :line_items => :line_items do
  extends "api/v1/orders/line_items/show"
end

child :transactions => :transactions do
  attributes :id
end

child :fulfillments => :fulfillments do
  attributes :id, :order_id, :tracking_company, :tracking_number, :created_at, :updated_at
  child :line_items => :line_items do
    extends "api/v1/orders/line_items/show"
  end
end

child :customer do
  attributes :id, :name, :email, :note, :orders_count, :total_spent, :created_at, :updated_at
end

collection @orders, root: :orders, object_root: false
attributes :id, :name, :note, :number, :subtotal_price, :token, :total_line_items_price, :total_price, :total_weight, :order_number, :financial_status, :financial_status_name, :fulfillment_status, :fulfillment_status_name, :cancel_reason, :cancelled_at 

child :transactions => :transactions do
  attributes :id
end

child :fulfillments => :fulfillments do
  attributes :id, :order_id, :tracking_company, :tracking_number
  child :line_items => :line_items do
    attributes :id, :product_id, :name, :quantity, :price, :sku, :title
    attribute product_variant_id: 'variant_id'
    attributes :variant_title, :vendor
  end
end

child :customer do
  attributes :id, :name, :email, :note, :orders_count, :total_spent
end

class MakeTimestampsNullFalse < ActiveRecord::Migration
  def up
    ["shippings", "weight_based_shipping_rates", "shop_themes", "shop_theme_settings", "shop_policies", "price_based_shipping_rates", "shop_tasks", "users", "products", "photos", "link_lists", "links", "product_variants", "kindeditors", "pages", "smart_collections", "smart_collection_rules", "smart_collection_products", "custom_collections", "custom_collection_products", "blogs", "articles", "comments", "tags", "order_fulfillments", "orders", "carts", "emails", "subscribes", "customers", "customer_tags", "customer_groups", "activities", "consumptions", "admin_users", "active_admin_comments", "payments", "api_clients", "cancel_reasons", "shops", "oauth_applications"].each do |table|
      change_column table, :created_at, :datetime , null: false
      change_column table, :updated_at, :datetime , null: false
    end
    ["order_histories", "order_transactions", "webhooks"].each do |table|
      change_column table, :created_at, :datetime , null: false
    end
  end

  def down
    ["shippings", "weight_based_shipping_rates", "shop_themes", "shop_theme_settings", "shop_policies", "price_based_shipping_rates", "shop_tasks", "users", "products", "photos", "link_lists", "links", "product_variants", "kindeditors", "pages", "smart_collections", "smart_collection_rules", "smart_collection_products", "custom_collections", "custom_collection_products", "blogs", "articles", "comments", "tags", "order_fulfillments", "orders", "carts", "emails", "subscribes", "customers", "customer_tags", "customer_groups", "activities", "consumptions", "admin_users", "active_admin_comments", "payments", "api_clients", "cancel_reasons", "shops", "oauth_applications"].each do |table|
      change_column table, :created_at, :datetime , null: true
      change_column table, :updated_at, :datetime , null: true
    end
    #["order_histories", "order_transactions", "webhooks", "oauth_access_grants", "oauth_access_tokens"].each do |table|
    ["order_histories", "order_transactions", "webhooks"].each do |table|
      change_column table, :created_at, :datetime , null: true
    end
  end
end

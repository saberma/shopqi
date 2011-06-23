# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110623141854) do

  create_table "articles", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body_html"
    t.boolean  "published",  :default => true
    t.integer  "user_id"
    t.boolean  "delta",      :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["blog_id"], :name => "index_articles_on_blog_id"
  add_index "articles", ["delta"], :name => "index_articles_on_delta"

  create_table "articles_tags", :id => false, :force => true do |t|
    t.integer "article_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "articles_tags", ["article_id"], :name => "index_articles_tags_on_article_id"
  add_index "articles_tags", ["tag_id"], :name => "index_articles_tags_on_tag_id"

  create_table "blogs", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title",       :null => false
    t.string   "commentable"
    t.string   "handle",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["shop_id"], :name => "index_blogs_on_shop_id"

  create_table "carts", :force => true do |t|
    t.integer  "shop_id",                  :null => false
    t.string   "token",      :limit => 32, :null => false
    t.string   "session_id", :limit => 32, :null => false
    t.string   "cart_hash",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carts", ["shop_id"], :name => "index_carts_on_shop_id"
  add_index "carts", ["token"], :name => "index_carts_on_token", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "article_id"
    t.string   "status"
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], :name => "index_comments_on_article_id"

  create_table "custom_collection_products", :force => true do |t|
    t.integer  "custom_collection_id"
    t.integer  "product_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_collection_products", ["custom_collection_id"], :name => "index_custom_collection_products_on_custom_collection_id"

  create_table "custom_collections", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.boolean  "published",      :default => true
    t.string   "handle",                           :null => false
    t.text     "body_html"
    t.string   "products_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_collections", ["shop_id"], :name => "index_custom_collections_on_shop_id"

  create_table "customer_addresses", :force => true do |t|
    t.integer "customer_id",               :null => false
    t.string  "name",                      :null => false
    t.string  "company",     :limit => 64
    t.string  "country",     :limit => 64
    t.string  "province",    :limit => 64
    t.string  "city",        :limit => 64
    t.string  "district",    :limit => 64
    t.string  "address1",                  :null => false
    t.string  "address2"
    t.string  "zip",         :limit => 12
    t.string  "phone",       :limit => 64, :null => false
  end

  add_index "customer_addresses", ["customer_id"], :name => "index_customer_addresses_on_customer_id"

  create_table "customer_groups", :force => true do |t|
    t.integer  "shop_id",                  :null => false
    t.string   "name",       :limit => 32, :null => false
    t.string   "query",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_groups", ["shop_id"], :name => "index_customer_groups_on_shop_id"

  create_table "customers", :force => true do |t|
    t.integer  "shop_id",                                           :null => false
    t.string   "name",              :limit => 16,                   :null => false
    t.string   "email",             :limit => 32,                   :null => false
    t.string   "note"
    t.float    "total_spent",                     :default => 0.0
    t.integer  "orders_count",                    :default => 0
    t.boolean  "accepts_marketing",               :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["shop_id"], :name => "index_customers_on_shop_id"

  create_table "emails", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title",                           :null => false
    t.string   "mail_type",                       :null => false
    t.text     "body",                            :null => false
    t.boolean  "include_html", :default => false
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kindeditors", :force => true do |t|
    t.string   "kindeditor_image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_lists", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.string   "handle"
    t.boolean  "system_default", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "link_lists", ["shop_id"], :name => "index_link_lists_on_shop_id"

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "link_type"
    t.string   "subject_id"
    t.string   "subject_params"
    t.string   "subject"
    t.integer  "link_list_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["link_list_id"], :name => "index_links_on_link_list_id"

  create_table "order_billing_addresses", :force => true do |t|
    t.integer "order_id",               :null => false
    t.string  "name",                   :null => false
    t.string  "company",  :limit => 64
    t.string  "country",  :limit => 64
    t.string  "province", :limit => 64
    t.string  "city",     :limit => 64
    t.string  "district", :limit => 64
    t.string  "address1",               :null => false
    t.string  "address2"
    t.string  "zip",      :limit => 12
    t.string  "phone",    :limit => 64, :null => false
  end

  add_index "order_billing_addresses", ["order_id"], :name => "index_order_billing_addresses_on_order_id"

  create_table "order_fulfillments", :force => true do |t|
    t.integer  "order_id",         :null => false
    t.string   "tracking_number"
    t.string   "tracking_company"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_fulfillments", ["order_id"], :name => "index_order_fulfillments_on_order_id"

  create_table "order_fulfillments_order_line_items", :id => false, :force => true do |t|
    t.integer "order_fulfillment_id", :null => false
    t.integer "order_line_item_id",   :null => false
  end

  add_index "order_fulfillments_order_line_items", ["order_fulfillment_id", "order_line_item_id"], :name => "index_order_fulfillments_items"
  add_index "order_fulfillments_order_line_items", ["order_fulfillment_id"], :name => "index_order_fulfillments_items_id"

  create_table "order_histories", :force => true do |t|
    t.integer  "order_id",                 :null => false
    t.string   "body",                     :null => false
    t.string   "url",        :limit => 64
    t.datetime "created_at"
  end

  add_index "order_histories", ["order_id"], :name => "index_order_histories_on_order_id"

  create_table "order_line_items", :force => true do |t|
    t.integer "order_id",                              :null => false
    t.integer "product_variant_id",                    :null => false
    t.float   "price",                                 :null => false
    t.integer "quantity",                              :null => false
    t.boolean "fulfilled",          :default => false
  end

  add_index "order_line_items", ["order_id"], :name => "index_order_line_items_on_order_id"

  create_table "order_shipping_addresses", :force => true do |t|
    t.integer "order_id",               :null => false
    t.string  "name",                   :null => false
    t.string  "company",  :limit => 64
    t.string  "country",  :limit => 64
    t.string  "province", :limit => 64
    t.string  "city",     :limit => 64
    t.string  "district", :limit => 64
    t.string  "address1",               :null => false
    t.string  "address2"
    t.string  "zip",      :limit => 12
    t.string  "phone",    :limit => 64, :null => false
  end

  add_index "order_shipping_addresses", ["order_id"], :name => "index_order_shipping_addresses_on_order_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id",                 :null => false
    t.string   "kind",       :limit => 16, :null => false
    t.float    "amount"
    t.datetime "created_at"
  end

  add_index "order_transactions", ["order_id"], :name => "index_order_transactions_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "shop_id",                              :null => false
    t.integer  "customer_id"
    t.string   "token",                  :limit => 32, :null => false
    t.string   "name",                   :limit => 32, :null => false
    t.integer  "number",                               :null => false
    t.integer  "order_number",                         :null => false
    t.string   "status",                 :limit => 16, :null => false
    t.string   "financial_status",       :limit => 16, :null => false
    t.string   "fulfillment_status",     :limit => 16, :null => false
    t.string   "email",                  :limit => 32, :null => false
    t.string   "shipping_rate",          :limit => 32
    t.string   "gateway",                :limit => 32
    t.float    "total_line_items_price",               :null => false
    t.float    "total_price",                          :null => false
    t.string   "note"
    t.datetime "closed_at"
    t.string   "cancel_reason",          :limit => 16
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["shop_id"], :name => "index_orders_on_shop_id"
  add_index "orders", ["token"], :name => "index_orders_on_token", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.boolean  "published",  :default => false
    t.string   "handle",                        :null => false
    t.text     "body_html"
    t.boolean  "delta",      :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["delta"], :name => "index_pages_on_delta"
  add_index "pages", ["shop_id"], :name => "index_pages_on_shop_id"

  create_table "photos", :force => true do |t|
    t.integer  "product_id"
    t.string   "product_image_uid"
    t.string   "product_image_format"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["product_id"], :name => "index_photos_on_product_id"

  create_table "product_options", :force => true do |t|
    t.integer "product_id", :null => false
    t.string  "name"
    t.integer "position"
  end

  add_index "product_options", ["product_id"], :name => "index_product_options_on_product_id"

  create_table "product_variants", :force => true do |t|
    t.integer  "shop_id",                                  :null => false
    t.integer  "product_id",                               :null => false
    t.float    "price",                :default => 0.0,    :null => false
    t.float    "weight",               :default => 0.0,    :null => false
    t.float    "compare_at_price"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.string   "sku"
    t.boolean  "requires_shipping",    :default => true
    t.integer  "inventory_quantity"
    t.string   "inventory_management"
    t.string   "inventory_policy",     :default => "deny"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_variants", ["product_id"], :name => "index_product_variants_on_product_id"

  create_table "products", :force => true do |t|
    t.integer  "shop_id",                        :null => false
    t.string   "handle",                         :null => false
    t.string   "title",                          :null => false
    t.boolean  "published",    :default => true
    t.text     "body_html"
    t.string   "product_type"
    t.string   "vendor"
    t.boolean  "delta",        :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["delta"], :name => "index_products_on_delta"
  add_index "products", ["shop_id"], :name => "index_products_on_shop_id"

  create_table "products_tags", :id => false, :force => true do |t|
    t.integer "product_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "products_tags", ["product_id"], :name => "index_products_tags_on_product_id"
  add_index "products_tags", ["tag_id"], :name => "index_products_tags_on_tag_id"

  create_table "shop_product_types", :force => true do |t|
    t.integer "shop_id"
    t.string  "name"
  end

  add_index "shop_product_types", ["shop_id"], :name => "index_shop_product_types_on_shop_id"

  create_table "shop_product_vendors", :force => true do |t|
    t.integer "shop_id"
    t.string  "name"
  end

  add_index "shop_product_vendors", ["shop_id"], :name => "index_shop_product_vendors_on_shop_id"

  create_table "shop_theme_settings", :force => true do |t|
    t.integer  "shop_theme_id", :null => false
    t.string   "name",          :null => false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_theme_settings", ["shop_theme_id"], :name => "index_shop_theme_settings_on_shop_theme_id"

  create_table "shop_themes", :force => true do |t|
    t.integer  "shop_id",     :null => false
    t.integer  "theme_id",    :null => false
    t.string   "load_preset", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shop_themes", ["shop_id"], :name => "index_shop_themes_on_shop_id"

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.string   "permanent_domain"
    t.string   "email"
    t.string   "phone"
    t.date     "deadline"
    t.string   "title"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "zip_code"
    t.string   "address"
    t.string   "keywords"
    t.string   "password"
    t.boolean  "password_enabled",    :default => false
    t.string   "password_message"
    t.boolean  "public",              :default => true
    t.integer  "orders_count",        :default => 0
    t.string   "order_number_format", :default => "\#{{number}}"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smart_collection_products", :force => true do |t|
    t.integer  "smart_collection_id"
    t.integer  "product_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smart_collection_products", ["smart_collection_id"], :name => "index_smart_collection_products_on_smart_collection_id"

  create_table "smart_collection_rules", :force => true do |t|
    t.integer  "smart_collection_id"
    t.string   "column"
    t.string   "relation"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smart_collection_rules", ["smart_collection_id"], :name => "index_smart_collection_rules_on_smart_collection_id"

  create_table "smart_collections", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.boolean  "published",      :default => true
    t.string   "handle",                           :null => false
    t.text     "body_html"
    t.string   "products_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smart_collections", ["shop_id"], :name => "index_smart_collections_on_shop_id"

  create_table "tags", :force => true do |t|
    t.integer  "shop_id",    :null => false
    t.string   "name",       :null => false
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["shop_id"], :name => "index_tags_on_shop_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",   :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "phone"
    t.text     "bio"
    t.boolean  "receive_announcements",                :default => true
    t.integer  "shop_id"
    t.boolean  "admin",                                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["shop_id"], :name => "index_users_on_shop_id"

end

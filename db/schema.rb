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

ActiveRecord::Schema.define(:version => 20110426120958) do

  create_table "kindeditors", :force => true do |t|
    t.string   "kindeditor_image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_lists", :force => true do |t|
    t.string   "title"
    t.string   "handle"
    t.boolean  "system_default", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "pages", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.boolean  "published",  :default => false
    t.string   "handle",                        :null => false
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "product_image_uid"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.text     "description"
    t.float    "price"
    t.float    "market_price"
    t.string   "number"
    t.string   "vendor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.string   "permanent_domain"
    t.string   "email"
    t.string   "phone"
    t.string   "theme",            :default => "shopqi"
    t.date     "deadline"
    t.string   "title"
    t.string   "province"
    t.string   "city"
    t.string   "address"
    t.string   "keywords"
    t.boolean  "public",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smart_collections", :force => true do |t|
    t.integer  "shop_id"
    t.string   "title"
    t.boolean  "published",  :default => false
    t.string   "handle",                        :null => false
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

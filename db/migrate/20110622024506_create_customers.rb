#encoding: utf-8
class CreateCustomers < ActiveRecord::Migration
  def self.up
    #顾客
    create_table :customers do |t|
      t.references :shop          , comment: "商品应从属于商店", null: false
      t.string :status            , comment: "状态"            , null: false  , limit: 8
      t.string :name              , comment: "名称"            , null: false  , limit: 16
      t.string :note              , comment: "备注"
      t.float :total_spent        , comment: "消费总额"        , default: 0
      t.integer :orders_count     , comment: "缓存订单数"      , default: 0
      t.boolean :accepts_marketing, comment: "是否接收营销邮件", default: true

      begin '顾客登陆信息'
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => "", :limit => 128

      ## Recoverable
      t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Encryptable
      # t.string :password_salt

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Token authenticatable
      t.string :authentication_token

      ## Invitable
      # t.string :invitation_token

      t.timestamps
      end
    end

    #地址信息
    create_table :customer_addresses do |t|
      t.references :customer            , comment: '所属顾客', null: false
      t.string     :name                , comment: '姓名'
      t.string     :company             , comment: '公司'    , limit: 64
      t.string     :country_code        , comment: '国家'    , limit: 10, default: 'CN' , null: false
      t.string     :province            , comment: '地区(省)', limit: 64
      t.string     :city                , comment: '城市'    , limit: 64
      t.string     :district            , comment: '区'      , limit: 64
      t.string     :address1            , comment: '地址'
      t.string     :address2            , comment: '地址 续'
      t.string     :zip                 , comment: '邮编'    , limit: 12
      t.string     :phone               , comment: '电话'    , limit: 64
      t.boolean    :default_address     , comment: '默认地址', default: false
    end

    #标记
    create_table :customer_tags do |t|
      t.references :shop, comment: '所属商店', null: false
      t.string :name    , comment: '姓名'    , null: false
      t.timestamps
    end

    create_table :customer_tags_customers, id: false do |t|
      t.references :customer    , comment: '所属顾客', null: false
      t.references :customer_tag, comment: '所属标签', null: false
    end

    add_index :customers              , :shop_id
    add_index :customers              , [:shop_id       , :email], unique: true
    add_index :customer_addresses     , :customer_id
    add_index :customer_tags          , :shop_id
    add_index :customer_tags_customers, :customer_id
    add_index :customer_tags_customers, :customer_tag_id
  end

  def self.down
    drop_table :customer_tags_customers
    drop_table :customer_tags
    drop_table :customer_addresses
    drop_table :customers
  end
end

#encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :shop, comment: "所属商店", null: false
      t.string :email   , comment: '邮箱'    , null: false

      t.timestamps
    end

    #发单人信息
    create_table :order_billing_addresses do |t|
      t.references :order, comment: '所属订单', null: false
      t.string :name     , comment: '姓名'    , null: false
      t.string :company  , comment: '公司'
      t.string :country  , comment: '国家'    , null: false
      t.string :province , comment: '地区(省)', null: false
      t.string :city     , comment: '城市'    , null: false
      t.string :address1 , comment: '地址'    , null: false
      t.string :address2 , comment: '地址 续'
      t.string :zip      , comment: '邮编'
      t.string :phone    , comment: '电话'    , null: false
    end

    #收货人信息
    create_table :order_shipping_addresses do |t|
      t.references :order, comment: '所属订单', null: false
      t.string :name     , comment: '姓名'    , null: false
      t.string :company  , comment: '公司'
      t.string :address1 , comment: '地址'    , null: false
      t.string :address2 , comment: '地址 续'
      t.string :city     , comment: '城市'    , null: false
      t.string :zip      , comment: '邮编'
      t.string :country  , comment: '国家'    , null: false
      t.string :province , comment: '地区(省)', null: false
      t.string :phone    , comment: '电话'    , null: false
    end

    add_index :orders                  , :shop_id
    add_index :order_billing_addresses  , :order_id
    add_index :order_shipping_addresses, :order_id
  end

  def self.down
    drop_table :order_shipping_addresses
    drop_table :order_billing_addresses
    drop_table :orders
  end
end

#encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :shop          , comment: "所属商店"                  , null: false
      t.string :token             , comment: '主键，防止id顺序访问'      , null: false, limit: 32
      t.string :name              , comment: '订单名称(格式化后的订单号)', null: false, limit: 32
      t.integer :number           , comment: '订单顺序号'                , null: false
      t.integer :order_number     , comment: '订单号码(顺序号+1000)'     , null: false
      t.string :status            , comment: '订单状态'                  , null: false, limit: 16
      t.string :financial_status  , comment: '支付状态'                  , null: false, limit: 16
      t.string :fulfillment_status, comment: '配送状态'                  , null: false, limit: 16
      t.string :email             , comment: '邮箱'                      , null: false, limit: 32
      t.string :shipping_rate     , comment: '发货方式'                  , limit: 32
      t.string :gateway           , comment: '付款方式'                  , limit: 32
      t.float :total_price        , comment: '总金额'                    , null: false
      t.string :note              , comment: '备注'

      t.timestamps
    end

    #订单商品
    create_table :order_line_items do |t|
      t.references :order          , comment: '所属订单'    , null: false
      t.references :product_variant, comment: '所属商品款式', null: false
      t.float :price               , comment: '购买时价格'  , null: false
      t.integer :quantity          , comment: '数量'        , null: false
      t.boolean :fulfilled         , comment: '发货状态'    , default: false
    end

    #配送记录
    create_table :order_fulfillments do |t|
      t.references :order       , comment: '所属订单', null: false
      t.string :tracking_number , comment: '快递单号'
      t.string :tracking_company, comment: '快递公司'
    end

    #配送记录相关订单商品
    create_table :order_fulfillments_order_line_items, id: false do |t|
      t.references :order_fulfillment, comment: '所属订单'    , null: false
      t.references :order_line_item  , comment: '所属订单商品', null: false
    end

    #发单人信息
    create_table :order_billing_addresses do |t|
      t.references :order, comment: '所属订单', null: false
      t.string :name     , comment: '姓名'    , null: false
      t.string :company  , comment: '公司'    , limit: 64
      t.string :country  , comment: '国家'    , limit: 64
      t.string :province , comment: '地区(省)', limit: 64
      t.string :city     , comment: '城市'    , limit: 64
      t.string :district , comment: '区'      , limit: 64
      t.string :address1 , comment: '地址'    , null: false
      t.string :address2 , comment: '地址 续'
      t.string :zip      , comment: '邮编'    , limit: 12
      t.string :phone    , comment: '电话'    , limit: 64  , null: false
    end

    #收货人信息
    create_table :order_shipping_addresses do |t|
      t.references :order, comment: '所属订单', null: false
      t.string :name     , comment: '姓名'    , null: false
      t.string :company  , comment: '公司'    , limit: 64
      t.string :country  , comment: '国家'    , limit: 64
      t.string :province , comment: '地区(省)', limit: 64
      t.string :city     , comment: '城市'    , limit: 64
      t.string :district , comment: '区'      , limit: 64
      t.string :address1 , comment: '地址'    , null: false
      t.string :address2 , comment: '地址 续'
      t.string :zip      , comment: '邮编'    , limit: 12
      t.string :phone    , comment: '电话'    , limit: 64  , null: false
    end

    add_index :orders                  , :shop_id
    add_index :orders                  , :token
    add_index :order_billing_addresses , :order_id
    add_index :order_shipping_addresses, :order_id
    add_index :order_line_items        , :order_id
  end

  def self.down
    drop_table :order_line_items
    drop_table :order_shipping_addresses
    drop_table :order_billing_addresses
    drop_table :orders
  end
end

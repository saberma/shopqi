#encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :shop             , comment: "所属商店"                  , null: false
      t.references :customer         , comment: "所属顾客"
      t.string :token                , comment: '主键，防止id顺序访问'      , null: false, limit: 32
      t.string :name                 , comment: '订单名称(格式化后的订单号)', null: false, limit: 32
      t.integer :number              , comment: '订单顺序号'                , null: false
      t.integer :order_number        , comment: '订单号码(顺序号+1000)'     , null: false
      t.string :status               , comment: '订单状态'                  , null: false, limit: 16
      t.string :financial_status     , comment: '支付状态'                  , null: false, limit: 16
      t.string :fulfillment_status   , comment: '配送状态'                  , null: false, limit: 16
      t.string :email                , comment: '邮箱'                      , null: false, limit: 32
      t.string :shipping_rate        , comment: '发货方式'                  , limit: 32
      t.integer :payment_id          , comment: '付款方式'
      t.float :total_line_items_price, comment: '商品总金额'                , null: false
      t.float :total_price           , comment: '总金额(含快递等费用)'      , null: false
      t.float :tax_price             , comment: '税收金额'                  , null: false, default: 0.0
      t.string :note                 , comment: '备注'
      t.datetime :closed_at          , comment: '关闭时间'
      t.string :cancel_reason        , comment: '取消原因'                  , limit: 16
      t.datetime :cancelled_at       , comment: '取消时间'

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

    #支付记录
    create_table :order_transactions do |t|
      t.references :order   , comment: '所属订单'         , null: false
      t.string :kind        , comment: '类型(authorization, sale       , capture)', null: false, limit: 16
      t.float :amount       , comment: '金额'
      t.datetime :created_at
    end

    #配送记录
    create_table :order_fulfillments do |t|
      t.references :order       , comment: '所属订单', null: false
      t.string :tracking_number , comment: '快递单号'
      t.string :tracking_company, comment: '快递公司'
      t.timestamps
    end

    #配送记录相关订单商品
    create_table :order_fulfillments_order_line_items, id: false do |t|
      t.references :order_fulfillment, comment: '所属订单'    , null: false
      t.references :order_line_item  , comment: '所属订单商品', null: false
    end

    #收货人信息
    create_table :order_shipping_addresses do |t|
      t.references :order, comment: '所属订单', null: false
      t.string :name     , comment: '姓名'    , null: false
      t.string :company  , comment: '公司'    , limit: 64
      t.string :country_code  , comment: '国家', limit: 10, default: 'CN', null: false
      t.string :province , comment: '地区(省)', limit: 64
      t.string :city     , comment: '城市'    , limit: 64
      t.string :district , comment: '区'      , limit: 64
      t.string :address1 , comment: '地址'    , null: false
      t.string :address2 , comment: '地址 续'
      t.string :zip      , comment: '邮编'    , limit: 12
      t.string :phone    , comment: '电话'    , limit: 64  , null: false
    end

    #订单历史
    create_table :order_histories do |t|
      t.references :order, comment: '所属订单'                                                 , null: false
      t.string :body     , comment: '内容'                                                     , null: false
      t.string :url      , comment: '相关地址(比如:保存配送记录再通过点击这个地址，输入订单号)', limit: 64
      t.datetime :created_at
    end

    add_index :orders                             , :shop_id
    add_index :orders                             , :customer_id
    add_index :orders                             , :token                , unique: true
    add_index :order_shipping_addresses           , :order_id
    add_index :order_line_items                   , :order_id
    add_index :order_transactions                 , :order_id
    add_index :order_fulfillments                 , :order_id
    add_index :order_fulfillments_order_line_items, :order_fulfillment_id , name: :index_order_fulfillments_items_id
    add_index :order_fulfillments_order_line_items, [:order_fulfillment_id, :order_line_item_id]                    , name: :index_order_fulfillments_items
    add_index :order_histories                    , :order_id
  end

  def self.down
    drop_table :order_histories
    drop_table :order_fulfillments_order_line_items
    drop_table :order_fulfillments
    drop_table :order_transactions
    drop_table :order_line_items
    drop_table :order_shipping_addresses
    drop_table :orders
  end
end

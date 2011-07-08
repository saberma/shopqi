# encoding: utf-8
#用途：用于存储商店基本信息
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name               , comment: "名称"
      t.string :domain             , comment: "域名"
      t.string :permanent_domain   , comment: "二级域名"
      t.string :email              , comment: "商店邮箱"
      t.string :phone              , comment: "商店电话"
      t.date   :deadline           , comment: "到期时间"
      t.string :title              , comment: "标题"
      t.string :province           , comment: "省份"
      t.string :city               , comment: "城市"
      t.string :district           , comment: "地区"
      t.string :zip_code           , comment: "邮政编码"
      t.string :address            , comment: "详细地址"
      t.string :keywords           , comment: "关键字"
      t.string :password           , comment: "密码"
      t.boolean :password_enabled  , comment: "是否让密码生效"                , default: false
      t.string :password_message   , comment: "提供给用户看的信息"
      t.boolean :public            , comment: "是否公开"                      , default: true
      t.integer :orders_count      , comment: "缓存订单数，用于生成订单顺序号", default: 0
      t.string :order_number_format, comment: "订单格式化规则"                , default: '#{{number}}'
      t.boolean :taxes_included    , comment: "税收是否包含在商品中"          , default: true
      t.boolean :tax_shipping      , comment: "是否要缴航运税"                , default: false

      t.timestamps
    end

    #商品类型
    create_table :shop_product_types do |t|
      t.references :shop, comment: "所属商店"
      t.string :name    , comment: "名称"
    end

    #商品厂商
    create_table :shop_product_vendors do |t|
      t.references :shop, comment: "所属商店"
      t.string :name    , comment: "名称"
    end

    #商店外观主题(可以支持多个主题切换)
    create_table :shop_themes do |t|
      t.references :shop   , comment: '所属商店'    , null: false
      t.references :theme  , comment: '所使用的主题', null: false
      t.string :load_preset, comment: '预设'        , null: false

      t.timestamps
    end

    #商店外观主题设置
    create_table :shop_theme_settings do |t|
      t.references :shop_theme, comment: '所属主题', null: false
      t.string :name          , comment: '名称'    , null: false
      t.string :value         , comment: '值'

      t.timestamps
    end

    #可发往国家
    create_table :countries do |t|
      t.references :shop, comment: "所属商店"
      t.string :code, comment: "国家编码"
      t.float :tax_percentage, comment: "税率"
      t.timestamps
    end

    #根据重量计算邮费
    create_table :weight_based_shipping_rates do |t|
      t.references :country
      t.float :price, comment: '价格'
      t.float :weight_low, comment: '重要区间（低）'
      t.float :weight_high, comment: '重要区间（高）'
      t.string :name, comment: '快递名'

      t.timestamps
    end


    add_index :shop_product_types  , :shop_id
    add_index :shop_product_vendors, :shop_id
    add_index :shop_themes         , :shop_id
    add_index :countries           , :shop_id
    add_index :weight_based_shipping_rates           , :country_id
    add_index :shop_theme_settings , :shop_theme_id
  end

  def self.down
    drop_table :weight_based_shipping_rates
    drop_table :countries
    drop_table :theme_settings
    drop_table :themes
    drop_table :shop_product_types
    drop_table :shop_product_vendors
    drop_table :shops
  end
end

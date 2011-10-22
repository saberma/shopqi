# encoding: utf-8
#用途：用于存储商店基本信息
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name                          , comment: "名称"                          , limit: 16
      t.string :phone                         , comment: "商店电话"                      , limit: 16
      t.string :plan                          , comment: "价格方案"                      , limit: 16,   default: 'basic'
      t.date   :deadline                      , comment: "到期时间"
      t.string :province                      , comment: "省份"                          , limit: 8
      t.string :city                          , comment: "城市"                          , limit: 8
      t.string :district                      , comment: "地区"                          , limit: 8
      t.string :zip_code                      , comment: "邮政编码"                      , limit: 16
      t.string :address                       , comment: "详细地址"                      , limit: 32
      begin '一般设置，发送邮件时显示发件方'
      t.string :email                         , comment: "商店邮箱"                      , limit: 64
      end
      begin '维护过程可以设置商店需要密码访问'
      t.string :password                      , comment: "密码"                          , limit: 64
      t.boolean :password_enabled             , comment: "是否让密码生效"                , default: false
      t.string :password_message              , comment: "提供给用户看的信息"            , limit: 255
      end
      t.integer :orders_count                 , comment: "缓存订单数，用于生成订单顺序号", default: 0
      t.string  :order_number_format          , comment: "订单格式化规则"                , default: '#{{number}}', limit: 32
      t.boolean :taxes_included               , comment: "税收是否包含在商品中"          , default: true
      t.boolean :tax_shipping                 , comment: "是否要缴航运税"                , default: false
      t.string  :customer_accounts            , comment: "顾客付款设置"                  , default: 'optional'
      t.string  :signup_source                , comment: "注册来源"                      , limit: 16
      begin '辅助字段'
      t.boolean :guided                       , comment: "是否已完成指南任务"            , default: false
      end
      t.timestamps
    end

    create_table :shop_domains do |t| #域名
      t.references :shop     , comment: "所属商店"
      t.string :subdomain    , comment: "子域名"                         , limit: 32
      t.string :domain       , comment: "域名"                           , limit: 32
      t.string :host         , comment: "host冗余(子域名+域名)，方便查询", limit: 64
      t.boolean :primary     , comment: "商店主域名"                     , default: true
      t.boolean :force_domain, comment: "重定向到这个域名"               , default: false
    end
    add_index :shop_domains, :shop_id
    add_index :shop_domains, :host

    create_table :shop_product_types do |t| #商品类型
      t.references :shop, comment: "所属商店"
      t.string :name    , comment: "名称"    , limit: 32
    end
    add_index :shop_product_types  , :shop_id

    create_table :shop_product_vendors do |t| #商品厂商
      t.references :shop, comment: "所属商店"
      t.string :name    , comment: "名称"    , limit: 32
    end
    add_index :shop_product_vendors, :shop_id

    create_table :shop_themes do |t| #商店外观主题(可以支持多个主题切换)
      t.references :shop   , comment: '所属商店'                       , null: false
      t.references :theme  , comment: '所使用的主题'                   , null: true # 自行上传主题时，与Theme对象不关联
      t.string :name       , comment: '名称'                           , null: false , limit: 32
      t.string :role       , comment: '角色(普通 手机 未发布 等待解压)', null: false , limit: 16
      t.string :load_preset, comment: '预设'                           , null: true  , limit: 16
      t.timestamps
    end
    add_index :shop_themes         , :shop_id

    create_table :shop_theme_settings do |t| #商店外观主题设置
      t.references :shop_theme, comment: '所属主题', null: false
      t.string :name          , comment: '名称'    , null: false, limit: 32
      t.string :value         , comment: '值'      , limit: 128
      t.timestamps
    end
    add_index :shop_theme_settings , :shop_theme_id

    create_table :shop_policies do |t|  #商店政策（退货政策，隐私政策以及服务条款）
      t.string :title               , comment: '政策名字'
      t.text :body                  , comment: '政策内容'
      t.references :shop
      t.timestamps
    end

    add_index :shop_policies , :shop_id

    create_table :countries do |t| #可发往国家
      t.references :shop     , comment: "所属商店"
      t.string :code         , comment: "国家编码", limit: 32
      t.float :tax_percentage, comment: "税率"
      t.timestamps
    end
    add_index :countries           , :shop_id

    create_table :weight_based_shipping_rates do |t| #根据重量计算邮费
      t.references :country
      t.float :price       , comment: '价格'
      t.float :weight_low  , comment: '重要区间（低）'
      t.float :weight_high , comment: '重要区间（高）'
      t.string :name       , comment: '快递名'        , limit: 32
      t.timestamps
    end
    add_index :weight_based_shipping_rates           , :country_id

    create_table :price_based_shipping_rates do |t| #根据重量计算邮费
      t.references :country
      t.float :price             , comment: '价格'
      t.float :min_order_subtotal, comment: '订单价格区间（低）'
      t.float :max_order_subtotal, comment: '订单价格区间（高）'
      t.string :name             , comment: '快递名'            , limit: 32
      t.timestamps
    end
    add_index :price_based_shipping_rates           , :country_id

    create_table :shop_tasks do |t| #指引任务
      t.references :shop
      t.string :name      , comment: '名称'  , size: 32
      t.boolean :completed, comment: '已完成', default: false
      t.timestamps
    end
    add_index :shop_tasks, :shop_id

  end

  def self.down
    drop_table :shop_tasks
    drop_table :price_based_shipping_rates
    drop_table :weight_based_shipping_rates
    drop_table :countries
    drop_table :theme_settings
    drop_table :themes
    drop_table :shop_product_types
    drop_table :shop_product_vendors
    drop_table :shop_domains
    drop_table :shops
  end
end

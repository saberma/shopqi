# encoding: utf-8
#用途：用于存储商店基本信息
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name             , comment: "名称"
      t.string :domain           , comment: "域名"
      t.string :permanent_domain , comment: "二级域名"
      t.string :email            , comment: "商店邮箱"
      t.string :phone            , comment: "商店电话"
      t.string :theme            , comment: "主题"              , default: 'shopqi'
      t.date   :deadline         , comment: "到期时间"
      t.string :title            , comment: "标题"
      t.string :province         , comment: "省份"
      t.string :city             , comment: "城市"
      t.string :district         , comment: "地区"
      t.string :zip_code         , comment: "邮政编码"
      t.string :address          , comment: "详细地址"
      t.string :keywords         , comment: "关键字"
      t.string :password         , comment: "密码"
      t.boolean :password_enabled, comment: "是否让密码生效"    , default: false
      t.string :password_message , comment: "提供给用户看的信息"
      t.boolean :public          , comment: "是否公开"          , default: true

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
      t.references :shop   , comment: '所属商店', null: false
      t.string :load_preset, comment: '预设'    , null: false

      t.timestamps
    end

    #商店外观主题设置
    create_table :shop_theme_settings do |t|
      t.references :theme, comment: '所属主题', null: false
      t.string :name     , comment: '名称'    , null: false
      t.string :value    , comment: '值'      , null: false

      t.timestamps
    end

    add_index :shop_product_types  , :shop_id
    add_index :shop_product_vendors, :shop_id
    add_index :shop_themes         , :shop_id
    add_index :shop_theme_settings , :theme_id
  end

  def self.down
    drop_table :theme_settings
    drop_table :themes
    drop_table :shop_product_types
    drop_table :shop_product_vendors
    drop_table :shops
  end
end

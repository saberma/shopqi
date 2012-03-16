# encoding: utf-8
class DropCountries < ActiveRecord::Migration # 不按国家区域收取运费，改为按省市收取快递费，有些快递不到的，则指定为EMS

  class Country < ActiveRecord::Base # faux model，源代码已经删除此实体文件
    belongs_to :shop
    has_many :weight_based_shipping_rates
    has_many :price_based_shipping_rates
  end

  def up
    remove_column :customer_addresses, :country_code # 删除实体中的country_code和tax属性
    remove_column :order_shipping_addresses, :country_code
    remove_column :shops, :taxes_included
    remove_column :shops, :tax_shipping
    remove_column :orders, :tax_price

    ShopTask.where(name: 'setup_taxes').delete_all # 删除税率对应的指南

    create_table :shippings do |t| # 物流
      t.references :shop     , comment: "所属商店"
      t.string :code         , comment: "编码(全国为000000)", limit: 8
      t.timestamps
    end
    add_index :shippings, :shop_id

    add_column :weight_based_shipping_rates, :shipping_id, :integer, comment: '归属物流'
    add_column :price_based_shipping_rates,  :shipping_id, :integer, comment: '归属物流'
    add_index :weight_based_shipping_rates, :shipping_id
    add_index :price_based_shipping_rates,  :shipping_id

    Country.all.each do |country|
      shipping = country.shop.shippings.create code: District::CHINA
      country.weight_based_shipping_rates.each do |weight|
        weight.update_attributes! shipping_id: shipping.id
      end
      country.price_based_shipping_rates.each do |price|
        price.update_attributes! shipping_id: shipping.id
      end
    end
    remove_column :weight_based_shipping_rates, :country_id
    remove_column :price_based_shipping_rates,  :country_id
    drop_table :countries
  end

  def down
    add_column :customer_addresses, :country_code, :string, comment: '国家', limit: 10, default: 'CN', null: false
    add_column :order_shipping_addresses, :country_code, :string, comment: '国家', limit: 10, default: 'CN', null: false
    add_column :shops, :taxes_included, :boolean, comment: '税收是否包含在商品中', default: true
    add_column :shops, :tax_shipping, :boolean, comment: '是否要缴航运税', default: false
    add_column :orders, :tax_price, :float, comment: '税收金额', default: 0.0, null: false

    Shop.all.each do |shop| # 恢复税率相应的指南
      shop.tasks.create name: :setup_taxes
    end

    create_table :countries do |t| #可发往国家
      t.references :shop     , comment: "所属商店"
      t.string :code         , comment: "国家编码", limit: 32
      t.float :tax_percentage, comment: "税率"
      t.timestamps
    end
    add_index :countries           , :shop_id
    add_column :weight_based_shipping_rates, :country_id, :integer, comment: '归属国家'
    add_column :price_based_shipping_rates,  :country_id, :integer, comment: '归属国家'
    add_index :weight_based_shipping_rates,  :country_id
    add_index :price_based_shipping_rates,   :country_id

    Shop.all.each do |shop|
      country = Country.create(shop_id: shop.id, code: 'CN') # 原有国家记录被删除后只能恢复时只能全部归为中国
      shop.shippings.each do |shipping|
        shipping.weight_based_shipping_rates.each do |weight|
          weight.update_attributes! country_id: country.id
        end
        shipping.price_based_shipping_rates.each do |price|
          price.update_attributes! country_id: country.id
        end
      end
    end

    remove_column :weight_based_shipping_rates, :shipping_id
    remove_column :price_based_shipping_rates,  :shipping_id
    drop_table :shippings
  end

end

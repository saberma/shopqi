# encoding: utf-8
class DropCountries < ActiveRecord::Migration # B2C不需要按区域收取不同的运费，免运费或者统一收取快递费更合理

  class Country < ActiveRecord::Base # faux model，源代码已经删除此实体文件
    belongs_to :shop
    has_many :weight_based_shipping_rates
    has_many :price_based_shipping_rates
  end

  def up
    add_column :weight_based_shipping_rates, :shop_id, :integer, comment: '归属商店'
    add_column :price_based_shipping_rates,  :shop_id, :integer, comment: '归属商店'
    add_index :weight_based_shipping_rates, :shop_id
    add_index :price_based_shipping_rates,  :shop_id
    Country.all.each do |country|
      country.weight_based_shipping_rates.each do |weight|
        weight.update_attributes! shop_id: country.shop_id
      end
      country.price_based_shipping_rates.each do |price|
        price.update_attributes! shop_id: country.shop_id
      end
    end
    remove_column :weight_based_shipping_rates, :country_id
    remove_column :price_based_shipping_rates,  :country_id
    drop_table :countries
  end

  def down
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
      shop.weight_based_shipping_rates.each do |weight|
        weight.update_attributes! country_id: country.id
      end
      shop.price_based_shipping_rates.each do |price|
        price.update_attributes! country_id: country.id
      end
    end

    remove_column :weight_based_shipping_rates, :shop_id
    remove_column :price_based_shipping_rates,  :shop_id
  end

end

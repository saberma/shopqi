#encoding: utf-8
class CreateCustomerGroups < ActiveRecord::Migration
  def self.up
    #顾客分组
    create_table :customer_groups do |t|
      t.references :shop, comment: "商品应从属于商店", null: false
      t.string :name    , comment: "名称"            , null: false, limit: 32
      t.string :term    , comment: "查询条件"        , limit: 32
      t.string :query   , comment: "过滤器字符串"    , limit: 512
      t.timestamps
    end

    add_index :customer_groups   , :shop_id
  end

  def self.down
    drop_table :customer_groups
  end
end

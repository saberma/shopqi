#encoding: utf-8
class CreateTags < ActiveRecord::Migration
  def self.up

    create_table :tags do |t|
      t.references :shop, comment:  "商品应从属于商店", null: false
      t.string :name    , comment:  "名称"            , null: false
    end

    #商品标签
    create_table :products_tags, id: false do |t|
      t.references :product, comment: '所属商品', null: false
      t.references :tag    , comment: '所属标签', null: false
    end
  end

  def self.down
    drop_table :products_tags
    drop_table :tags
  end
end

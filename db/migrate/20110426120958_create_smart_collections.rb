#encoding: utf-8
class CreateSmartCollections < ActiveRecord::Migration
  def self.up
    create_table :smart_collections do |t|
      t.integer :shop_id, comment: '所属网店'
      t.string :title, comment: '标题'
      t.boolean :published, comment: '是否可见', default: true
      t.string :handle, comment: '用于模板中的Permalink/Handle', null: false
      t.text :body_html, comment: '内容'
      t.string :products_order, comment: '归属商品的排序'

      t.timestamps
    end

    create_table :smart_collection_rules do |t|
      t.integer :smart_collection_id, comment: '所属集合'
      t.string :column, comment: '列'
      t.string :relation, comment: '判断关系'
      t.string :condition, comment: '判断值'

      t.timestamps
    end

    create_table :smart_collection_products do |t|
      t.integer :smart_collection_id, comment: '所属集合'
      t.integer :product_id, comment: '关联商品'
      t.integer :position, comment: '排序序号'

      t.timestamps
    end

  end

  def self.down
    drop_table :smart_collection_products
    drop_table :smart_collection_rules
    drop_table :smart_collections
  end
end

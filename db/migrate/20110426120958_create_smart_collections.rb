#encoding: utf-8
class CreateSmartCollections < ActiveRecord::Migration
  def self.up
    create_table :smart_collections do |t|
      t.integer :shop_id, comment: '所属网店'
      t.string :title, comment: '标题'
      t.boolean :published, comment: '是否可见', default: false
      t.text :body_html, comment: '内容'

      t.timestamps
    end
  end

  def self.down
    drop_table :smart_collections
  end
end

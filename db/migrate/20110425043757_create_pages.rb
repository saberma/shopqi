#encoding: utf-8
class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :shop_id, comment: '所属网店'
      t.string :title, comment: '标题'
      t.text :content, comment: '内容'

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end

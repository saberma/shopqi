#encoding: utf-8
class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references :shop,:comment => "商品应从属于商店"
      t.string :title,:comment => "标题,例如:ipod"
      t.text :description,:comment => "商品描述"
      t.float :price ,:comment => "商品价格"
      t.float :market_price,:comment => "商品市场价格，即销售价格"
      t.string :number ,:comment => "编号"
      t.string :vendor ,:comment => "品牌(供应商)"
      t.string :tags, :comment => "关键词"

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end

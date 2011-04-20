# encoding: utf-8
#用途：用于存储商店基本信息
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name, :comment => "商店名"
      t.string :domain, :comment => "域名"
      t.string :permanent_domain , :comment => "二级域名"
      t.string :email,:comment => "商店邮箱"
      t.string :phone ,:comment => "商店电话"
      t.string :theme,:default => 'shopqi', :comment => "主题"
      t.date   :deadline,:comment => "到期时间"
      t.string :title,:comment => "标题"
      t.string :province,:comment => "省份"
      t.string :city,:comment => "城市"
      t.string :address ,:comment => "详细地址"
      t.string :keywords, :comment => "关键字"
      t.boolean :public,:comment => "是否公开"

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end

# encoding: utf-8
#用途：用于存储该商店用于购买方案的消费记录
class CreateConsumptions < ActiveRecord::Migration
  def self.up
    create_table :consumptions do |t|
      t.string          :token                 , comment: '主键，用于out_trade_no'      , null: false, limit: 32
      t.references      :shop                  ,comment: '关联商店'
      t.integer         :quantity              ,comment: '购买月数'
      t.float           :price                 ,comment: '购买单价'
      t.boolean         :status                ,comment: '支付状态'
      t.integer         :plan_type_id          ,comment: '关联方案'

      t.timestamps
    end
  end

  def self.down
    drop_table :consumptions
  end
end

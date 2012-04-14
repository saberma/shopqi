#encoding: utf-8
class AddTradeNoToOrder < ActiveRecord::Migration

  def change
    add_column :orders, :trade_no, :string, comment: '支付宝在线支付交易号', limit: 16 # 用于集成发货接口
  end

end

#encoding: utf-8
class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.references :shop               , comment: "关联商店"
      t.string     :partner            , comment: "合作者身份id"
      t.integer    :payment_type_id    , comment: "支付类型"
      t.string     :key                , comment: "交易安全校验码"
      t.string     :account            , comment: "账号"
      t.text       :message            , comment: '信息'
      t.string     :name               , comment: '支付名(用于普通支付方式)'

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end

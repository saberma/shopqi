#encoding: utf-8
class CreateDiscounts < ActiveRecord::Migration

  def change
    create_table :discounts do |t|
      t.references :shop           , comment: '所属商店'
      t.string :code               , comment: "优惠码"                             , limit: 32
      t.string :discount_type      , comment:  '优惠码类型，代金券、折扣券、免运费', limit: 16
      t.float :value               , comment: "优惠值(x元或者百分之x)"
      t.integer :used_times        , comment: "已使用次数", default: 0
      t.integer :usage_limit       , comment: "限制数量"
      #t.string :applies_to_resource, comment: "优惠对象(所有订单、顾客组等)"       , limit: 32
      #t.integer :applies_to_id     , comment: "优惠对象id"
      #t.float :minimum_order_amount, comment: "订单总价不低于x"
      #t.date :starts_at            , comment: "起始日期"
      #t.date :ends_at              , comment: "终止日期"
    end

    create_table :order_discounts do |t|
      t.references :order, comment: '所属订单'
      t.string :code     , comment: "优惠码"  , limit: 32
      t.float :amount    , comment:  '优惠x元'
    end

    add_column :orders, :subtotal_price, :float, comment: '小计(包含商品和优惠码)'
    Order.all.each do |order|
      order.subtotal_price = order.total_line_items_price
      order.save
    end
  end

end

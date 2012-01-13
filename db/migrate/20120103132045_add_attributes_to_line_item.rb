#encoding: utf-8
class AddAttributesToLineItem < ActiveRecord::Migration # 增加商品款式冗余字段，在商品被删除的情况下，仍能显示订单商品

  def change
    add_column :order_line_items, :product_id       , :integer, comment: '商品ID'
    add_column :order_line_items, :title            , :string , comment: '商品标题'
    add_column :order_line_items, :variant_title    , :string , comment: '款式名称1 / 款式名称2'
    add_column :order_line_items, :name             , :string , comment: '商品标题 - 款式名称1 / 款式名称2'
    add_column :order_line_items, :vendor           , :string , comment: '商品厂商'
    add_column :order_line_items, :requires_shipping, :boolean, comment: '要求送货地址'
    add_column :order_line_items, :grams            , :integer, comment: '重量单位:克'
    add_column :order_line_items, :sku              , :string , comment: '商品唯一标识符'

    OrderLineItem.reset_column_information
    OrderLineItem.all.each do |line_item| # 处理原有数据
      variant = line_item.product_variant
      if variant
        product = variant.product
        line_item.product_id = product.id
        line_item.title = product.title
        line_item.variant_title = variant.title
        line_item.name = variant.name
        line_item.vendor = product.vendor
        line_item.requires_shipping = variant.requires_shipping
        line_item.grams = (variant.weight * 1000).to_i
        line_item.sku = variant.sku
        line_item.save
      end
    end
  end

end

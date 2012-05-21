#encoding: utf-8
class AddPostionToProductVariant < ActiveRecord::Migration
  def change
    add_column :product_variants, :position, :integer, comment: '位置'
    Shop.all.each do |shop|
      shop.products.each do |product|
        product.variants.each_with_index do |variant, index|
          variant.update_attribute :position, index + 1
        end
      end
    end
  end
end

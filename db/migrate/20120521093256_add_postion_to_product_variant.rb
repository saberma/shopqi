#encoding: utf-8
class AddPostionToProductVariant < ActiveRecord::Migration
  def change
    add_column :product_variants, :position, :integer, comment: '位置'
  end
end

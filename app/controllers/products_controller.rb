#encoding: utf-8
class ProductsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){current_user.shop}
  expose(:products){shop.products}
  expose(:product)

  def create
    product.save
    redirect_to products_path,:notice => "新增商品成功"
  end

end

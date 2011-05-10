#encoding: utf-8
class ProductsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){current_user.shop}
  expose(:products){shop.products}
  expose(:product)

  def new
    product.photos.build
  end

  def create
    if product.save
      render edit_products_path, notice: "新增商品成功!"
    else
      render action:'new'
    end
  end

end

#encoding: utf-8
class ProductsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop) { current_user.shop }
  expose(:products) do
    if params[:search]
      shop.products.search(params[:search]).all
    else
      shop.products
    end
  end
  expose(:product)
  expose(:types) { shop.types }
  expose(:types_options) { types.map {|t| [t.name, t.id]} }
  expose(:vendors) { shop.vendors }
  expose(:vendors_options) { vendors.map {|t| [t.name, t.id]} }

  def new
    #保证至少有一个款式
    product.variants.build if product.variants.empty?
  end

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

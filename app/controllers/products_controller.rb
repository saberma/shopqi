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
  expose(:inventory_managements) { KeyValues::Product::Inventory::Manage.options }
  expose(:inventory_policies) { KeyValues::Product::Inventory::Policy.all }
  expose(:options) { KeyValues::Product::Option.options }

  def new
    #保证至少有一个款式
    product.variants.build if product.variants.empty?
    product.photos.build
  end

  def create
    if product.save
      redirect_to products_path, notice: "新增商品成功!"
    else
      render action: :new
    end
  end
end

# encoding: utf-8
class CustomCollectionProductsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:custom_collections) { current_user.shop.custom_collections }
  expose(:custom_collection)
  expose(:custom_collection_products) { custom_collection.products }
  expose(:custom_collection_product)

  def create
    custom_collection_product.save
    render json: custom_collection_product.to_json(include: :product)
  end

  def destroy
    custom_collection_product.destroy
    render :json => custom_collection_product
  end
end

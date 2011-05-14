# encoding: utf-8
class ProductVariantsController < ApplicationController
  prepend_before_filter :authenticate_user!
  expose(:shop) { current_user.shop }
  expose(:products) { shop.products }
  expose(:product)
  expose(:variants) { product.variants }
  expose(:variant)
  expose(:variant_json) { varaint.to_json except: [ :created_at, :updated_at ] }

  def create
    variant.save
    render json: variant_json
  end
end

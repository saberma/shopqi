# encoding: utf-8
class ProductVariantsController < ApplicationController
  prepend_before_filter :authenticate_user!
  expose(:shop) { current_user.shop }
  expose(:products) { shop.products }
  expose(:product)
  expose(:product_variants) { product.variants }
  expose(:product_variant)
  expose(:product_variant_json) { product_variant.to_json except: [ :created_at, :updated_at ] }

  def create
    product_variant.save
    render json: product_variant_json
  end

  def update
    product_variant.save
    render json: product_variant_json
  end
end

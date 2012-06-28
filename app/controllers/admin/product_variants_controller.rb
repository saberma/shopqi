# encoding: utf-8
class Admin::ProductVariantsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  expose(:shop) { current_user.shop }
  expose(:products) { shop.products }
  expose(:product)
  expose(:product_variants) { product.variants }
  expose(:product_variant)
  expose(:product_variant_json) { product_variant.to_json except: [ :created_at, :updated_at ] }

  def create
    if product_variant.save
      render json: product_variant_json
    else
      render nothing: true
    end
  end

  def update
    if product_variant.save
      render json: product_variant_json
    else
      render nothing: true
    end
  end

  # 批量修改
  def set
    operation = params[:operation]
    ids = params[:variants]
    ProductVariant.transaction do
      if operation.to_sym == :destroy
        product_variants.find(ids).map(&:destroy)
      elsif [:price, :inventory_quantity].include?(operation.to_sym)
        product_variants.find(ids).each do |variant|
          variant.update_attribute operation, params[:new_value]
        end
      end
    end
    render nothing: true
  end

  def sort
    params[:variant].each_with_index do |id, index|
      product.variants.find(id).update_attribute :position,  index + 1
    end
    render nothing: true
  end
end

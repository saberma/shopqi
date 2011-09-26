# encoding: utf-8
class ProductVariantsController < AppController
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

  # 批量修改
  def set
    operation = params[:operation]
    ids = params[:variants]
    if operation.to_sym == :destroy
      product_variants.find(ids).map(&:destroy)
    else
      product_variants.where(id:ids).update_all operation => params[:new_value]
    end
    render nothing: true
  end
end

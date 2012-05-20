# encoding: utf-8
class Admin::ProductOptionsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  expose(:shop) { current_user.shop }
  expose(:products) { shop.products }
  expose(:product)
  expose(:product_options) { product.options }
  expose(:product_option)

  def move
    product_option.move! params[:dir].to_i
    render json: {
      options: product.options.as_json( methods: [:value, :first, :last], except: [ :created_at, :updated_at ] ),
      variants: product.variants.as_json( except: [ :created_at, :updated_at ])
    }
  end
end

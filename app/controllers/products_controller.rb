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
  expose(:product_json) { product.to_json(methods: [:tags_text, :collection_ids], except: [ :created_at, :updated_at ]) }
  expose(:variants) { product.variants }
  expose(:variant) { variants.build }
  expose(:types) { shop.types }
  expose(:types_options) { types.map {|t| [t.name, t.name]} }
  expose(:vendors) { shop.vendors }
  expose(:vendors_options) { vendors.map {|t| [t.name, t.name]} }
  expose(:inventory_managements) { KeyValues::Product::Inventory::Manage.options }
  expose(:inventory_policies) { KeyValues::Product::Inventory::Policy.all }
  expose(:options) { KeyValues::Product::Option.all.map {|t| [t.name, t.name]} }
  expose(:tags) { shop.tags.previou_used }
  expose(:custom_collections) { shop.custom_collections }
  expose(:publish_states) { KeyValues::PublishState.options }

  def new
    #保证至少有一个款式
    product.variants.build if product.variants.empty?
    product.photos.build
  end

  def create
    if product.save
      redirect_to product_path(product), notice: "新增商品成功!"
    else
      render action: :new
    end
  end

  def destroy
    product.destroy
    redirect_to products_path
  end

  def update
    product.save
    render json: product_json
  end

  #更新可见性
  def update_published
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    product.save
    render template: "shared/msg"
  end
end

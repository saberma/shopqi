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
  expose(:product_json) do
    product.to_json({
      include: { options: { methods: :value, except: [ :created_at, :updated_at ] } },
      methods: [:tags_text, :collection_ids],
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:variants) { product.variants }
  expose(:variant) { variants.new }
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

  def index
    @products_json = products.to_json({include: [:variants, :options], except: [:created_at, :updated_at]})
  end

  def inventory
    @product_variants = ProductVariant.joins(:product).where(inventory_management: 'shopqi', product: {shop_id: shop.id})
  end

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
    product.reload
    render json: product_json
  end

  # 批量修改
  def set
    operation = params[:operation].to_sym
    ids = params[:products]
    if [:publish, :unpublish].include? operation #可见性
      products.where(id:ids).update_all published: (operation == :publish)
    elsif operation == :destroy #删除
      products.find(ids).map(&:destroy)
    else #加入集合
    end
    render nothing: true
  end

  # 复制
  def duplicate
    new_product = product.clone
    new_product.variants = product.variants.map(&:clone)
    new_product.options = product.options.map(&:clone)
    new_product.collection_products = product.collection_products.map(&:clone)
    new_product.tags_text = product.tags_text
    new_product.update_attribute :title, params[:new_title]
    render json: {id: new_product.id}
  end

  #更新可见性
  def update_published
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    product.save
    render template: "shared/msg"
  end
end

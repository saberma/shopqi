#encoding: utf-8
class ProductsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop) { current_user.shop }
  expose(:products) do
    if params[:search]
      shop.products.metasearch(params[:search]).all
    else
      shop.products
    end
  end
  expose(:product)
  expose(:product_json) do
    product.to_json({
      include: { options: { methods: :value, except: [ :created_at, :updated_at ] },photos: {methods: :icon} },
      methods: [:tags_text, :collection_ids],
      except: [ :created_at, :updated_at ]
    })
  end
  expose(:variants) { product.variants }
  #expose(:variant) { variants.new }
  expose(:types) { shop.types }
  expose(:types_options) { types.map {|t| [t.name, t.name]} }
  expose(:vendors) { shop.vendors }
  expose(:vendors_options) { vendors.map {|t| [t.name, t.name]} }
  expose(:inventory_managements) { KeyValues::Product::Inventory::Manage.options }
  expose(:inventory_policies) { KeyValues::Product::Inventory::Policy.all }
  expose(:options) { KeyValues::Product::Option.all.map {|t| [t.name, t.name]} }
  expose(:tags) { shop.tags.previou_used(1) }
  expose(:custom_collections) { shop.custom_collections }
  expose(:publish_states) { KeyValues::PublishState.options }
  expose(:photos){ product.photos }
  expose(:photo){ Photo.new }

  def index
    @products_json = products.to_json({include: [:variants, :options], except: [:created_at, :updated_at],methods:[:index_photo]})
  end

  def inventory
    @product_variants = ProductVariant.joins(:product).where(inventory_management: 'shopqi', product: {shop_id: shop.id})
  end

  def new
    #保证至少有一个款式
    product.variants.build if product.variants.empty?
  end

  def create
    images = params[:product][:images] || []
    images.each_with_index do |i,pos|
      product.photos.build(product_image: i,position: pos)
    end
    #保存商品图片
    if product.save
      Activity.log product,'new',current_user
      redirect_to product_path(product, new_product: true), notice: "新增商品成功!"
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
    product.options.reject! {|option| option.destroyed?} #rails bug：使用_destroy标记删除后，需要reload后，删除集合中的元素才消失，而reload后value值将被置空
    Activity.log product,'edit',current_user
    render json: product_json
  end

  # 批量修改
  def set
    operation = params[:operation].to_sym
    ids = params[:products]
    if [:publish, :unpublish].include? operation #可见性
      products.where(id:ids).update_all published: (operation == :publish)
      products.where(id:ids).map{|product|log_published(product)}
    elsif operation == :destroy #删除
      products.find(ids).map(&:destroy)
    else #加入集合
      #'add_to_collection-1'
      collection_id = operation.to_s.sub 'add_to_collection-', ''
      collection = shop.custom_collections.find(collection_id)
      ids.each do |id|
        unless collection.collection_products.exists?(product_id: id)
          collection.collection_products.build product_id: id
        end
      end
      collection.save
    end
    render nothing: true
  end

  # 复制
  def duplicate
    new_product = product.dup
    new_product.variants = product.variants.map(&:dup)
    new_product.options = product.options.map(&:dup).each{|o| o.position = nil } # Fixed: #159 position不为空导致排序报错
    new_product.collection_products = product.collection_products.map(&:dup)
    new_product.tags_text = product.tags_text
    new_product.update_attribute :title, params[:new_title]
    render json: {id: new_product.id}
  end

  #更新可见性
  def update_published
    flash.now[:notice] = I18n.t("flash.actions.update.notice")
    product.save
    log_published(product)
    render template: "shared/msg"
  end

  protected

  def log_published(product)
    handle = product.published ? 'published' : 'hidden'
    Activity.log product,handle,current_user
  end
end

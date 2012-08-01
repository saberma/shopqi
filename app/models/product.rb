# encoding: utf-8
class Product < ActiveRecord::Base
  include Models::Handle
  belongs_to :shop
  has_many :photos             , dependent: :destroy           , order: 'position asc'
  has_many :variants           , dependent: :destroy           , class_name: 'ProductVariant'         , order: 'position asc'
  has_many :options            , dependent: :destroy           , class_name: 'ProductOption'          , order: 'position asc'
  has_many :collection_products, dependent: :destroy           , class_name: 'CustomCollectionProduct'
  has_many :collections        , class_name: 'CustomCollection', through: :collection_products        , source: :custom_collection
  has_and_belongs_to_many :tags, order: 'id asc'
  # 标签
  attr_accessor :tags_text,:images
  attr_accessible :handle, :title, :published, :body_html, :price, :product_type, :vendor, :tags_text, :images, :photos_attributes, :variants_attributes, :options_attributes, :collection_ids

  scope :published, where(published: true)

  accepts_nested_attributes_for :photos  , allow_destroy: true
  accepts_nested_attributes_for :variants, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true

  validates_presence_of :title, :product_type, :vendor

  #商品列表中显示的产品图片
  def index_photo
    photo('thumb')
  end

  def photo(version = :icon)
    unless photos.empty?
      photos.first.send(version)
    else
      "/assets/admin/no-image-#{version}.gif"
    end
  end

  searchable do
    integer :shop_id, references: Shop
    text :title, :body_html, :product_type, :vendor
    text :variants_text do
      variants.map do |variant|
        [variant.option1, variant.option2, variant.option3, variant.sku]
      end
    end
  end

  before_create do
    if self.variants.empty?
      self.variants.build price: 0.0, weight: 0.0
    end
    if self.options.empty?
      option_name = KeyValues::Product::Option.first.name
      self.options.build name: option_name
      self.variants.first.option1 = "默认#{option_name}"
    end
  end

  before_save do
    self.make_valid(shop.products)
  end

  def tags_text
    @tags_text ||= tags.map(&:name).join(', ')
  end

  after_save do
    product_tags = self.tags.map(&:name)
    # 删除tag
    (product_tags - Tag.split(tags_text)).each do |tag_text|
      tag = shop.tags.where(name: tag_text,category: 1).first
      tags.delete(tag)
    end
    # 新增tag
    (Tag.split(tags_text) - product_tags).each do |tag_text|
      tag = shop.tags.where(name: tag_text, category: 1).first
      if tag
        # 更新时间，用于显示最近使用过的标签
        tag.touch
      else
        tag = shop.tags.create(name: tag_text, category: 1) unless tag
      end
      self.tags << tag
    end
  end

  def available
    self.published
  end

  def url
    "/products/#{self.handle}"
  end

  begin 'shop' # 只供商店调用

    def shop_as_json(options = nil) # 不能以as_json，会与后台管理的to_json冲突(options同名)
      {
        id: self.id,
        handle: self.handle,
        title: self.title,
        price: self.price,
        url: self.url,
        available: self.available,
        options: self.options.map(&:name),
        variants: self.variants.map(&:shop_as_json),
        featured_image: self.featured_image # 配合api.jquery.js的resizeImage方法
      }
    end

    def featured_image
      Hash[*Photo::VERSION_KEYS.map do |version|
        [version, self.photo(version)]
      end.flatten]
    end

  end

end

#商品款式
class ProductVariant < ActiveRecord::Base
  belongs_to :shop #冗余字段，前台商店下订单时使用
  belongs_to :product
  acts_as_list scope: :product
  validates_with SkuValidator
  attr_accessible :price, :weight, :compare_at_price, :option1, :option2, :option3, :sku, :requires_shipping, :inventory_quantity, :inventory_management, :inventory_policy, :position

  before_create do
    self.shop_id = self.product.shop_id
  end

  before_save do
    self.price ||= 0.0 # 价格、重量一定要有默认值
    self.weight ||= 0.0
  end

  after_save do
    min_price = self.product.variants.map(&:price).min || self.price
    self.product.update_attributes price: min_price # 商品冗余最小价格，方便集合排序
  end

  after_destroy do
    min_price = self.product.variants.map(&:price).min
    self.product.update_attributes price: min_price
  end

  def options
    [option1, option2, option3].compact
  end

  def title
    self.options.join(' / ') if product.variants.size > 1
  end

  def name
    (product.variants.size > 1) ? "#{product.title} - #{self.title}" : product.title
  end

  begin 'inventory' # 库存

    def inventory_policy_name
      KeyValues::Product::Inventory::Policy.find_by_code(inventory_policy).name
    end

    def manage_inventory? # 需要管理库存,下单时减一，销单时加一
      !self.inventory_management.blank?
    end

    def policy_deny? # 库存不足时拒绝继续销售
      self.inventory_policy == 'deny'
    end

    def low_in_stock? # 库存不足
      stock = self.inventory_quantity || 0
      stock <= 0
    end

    def available
      !(manage_inventory? and policy_deny? and low_in_stock?)
    end

  end


  begin 'shop' # 只供商店调用的json

    def shop_as_json(options = nil)
      {
        id: self.id,
        option1: self.option1,
        option2: self.option2,
        option3: self.option3,
        available: self.available,
        title: self.title,
        price: self.price,
        compare_at_price: self.compare_at_price,
        weight: self.weight,
        sku: self.sku,
      }
    end

  end
end

class ProductOption < ActiveRecord::Base # 商品选项
  belongs_to :product
  acts_as_list scope: :product
  attr_accessible :name, :value, :position
  attr_accessor :value, :first, :last # 辅助值，用于保存至商品款式中

  before_create do # 新增的选项默认值要设置到所有款式中
    product.variants.each do |variant|
      variant.update_column "option#{position}", value
    end if value.present?
  end

  before_destroy do # 更新商品所有款式
    options_size = product.options.size
    product.variants.each do |variant|
      (position...options_size).each do |i|
        variant.update_column "option#{i}", variant.send("option#{i+1}")
      end
      variant.update_column "option#{options_size}", nil
    end
  end

  def first
    self.first?
  end

  def last
    self.last?
  end

  def move!(dir)
    self.class.transaction do
      pos = self.position # move后position会改变
      if dir == -1
        self.move_higher
      elsif dir == 1
        self.move_lower
      else
        return
      end
      product.variants.each do |variant|
        tmp = variant.send("option#{pos}")
        variant.send("option#{pos}=", variant.send("option#{pos+dir}"))
        variant.send("option#{pos+dir}=", tmp)
        variant.save
      end
    end
  end
end

class Photo < ActiveRecord::Base
  belongs_to :product
  default_scope order: 'position asc'
  attr_accessible :product_image, :position
  VERSION_KEYS = []

  image_accessor :product_image do
    storage_path{ |image|
      "#{self.product.shop.id}/products/#{self.product.id}/#{image.basename}_#{rand(1000)}.#{image.format}" # data/shops/1/products/1/foo_45.jpg
    }
  end

  validates_size_of :product_image, maximum: 8000.kilobytes
  validates_with StorageValidator

  validates_property :mime_type, of: :product_image, in: %w(image/jpeg image/jpg image/png image/gif), message:  "格式不正确"

  #定义图片显示大小种类
  def self.versions(opt={})
    opt.each_pair do |k,v|
      VERSION_KEYS << k
      define_method k do
        if product_image
          product_image.thumb(v).url
        end
      end
    end
  end

  def shop # 直接使用delegate :shop, to: :product在新增商品带图片的情况下会报500错误 #416
    product ? product.shop : nil
  end

  #显示在产品列表的缩略图(icon)
  #后台管理商品详情(small)
  versions pico: '16x16', icon: '32x32', thumb: '50x50', small:'100x100', compact: '160x160', medium: '240x240', large: '480x480', grande: '600x600', original: '1024x1024'

end

CustomCollection


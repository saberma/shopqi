#encoding: utf-8
class ProductDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(product)
    @product = product
  end

  delegate :id, :handle, :title, :price, :available, :vendor, :tags, to: :@product

  def variants
    @product.variants.map do |variant|
      ProductVariantDrop.new variant
    end
  end
  memoize :variants

  def options
    @product.options.map do |option|
      ProductOptionDrop.new option
    end
  end
  memoize :options

  def images
    @product.photos.map do |image|
      ProductImageDrop.new image
    end
  end
  memoize :images

  def url
    #Rails.application.routes.url_helpers.product_path(@product)
    "/products/#{@product.handle}"
  end

  def type
    @product.product_type
  end

  def price_varies
    @product.variants.map(&:price).uniq.size > 1
  end
  memoize :price_varies

  def price_min
    price
  end

  def compare_at_price_varies
    @product.variants.map(&:compare_at_price).uniq.size > 1
  end
  memoize :compare_at_price_varies

  def compare_at_price_max
    @product.variants.map(&:compare_at_price).max
  end
  memoize :compare_at_price_max

  def compare_at_price_min
    @product.variants.map(&:compare_at_price).min
  end
  memoize :compare_at_price_min

  def description
    @product.body_html
  end

  def featured_image
    ProductImageDrop.new @product.photos.first
  end

  def as_json(options = nil)
    @product.shop_as_json
  end
end

class ProductImageDrop < Liquid::Drop

  def initialize(image)
    @image = image
  end

  def version(size)
    @image.send(size)
  end

end

class ProductOptionDrop < Liquid::Drop

  def initialize(option)
    @option = option
  end

  def as_json(options={})
    @option.name
  end

  def to_s
    @option.name
  end

end

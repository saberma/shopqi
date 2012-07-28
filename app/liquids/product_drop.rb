#encoding: utf-8
class ProductDrop < Liquid::Drop

  def initialize(product)
    @product = product
  end

  delegate :id, :handle, :title, :url, :price, :available, :vendor, :tags, to: :@product, allow_nil: true

  def variants
    @variants ||= @product.variants.map do |variant|
      ProductVariantDrop.new variant
    end
  end

  def options
    @options ||= @product.options.map do |option|
      ProductOptionDrop.new option
    end
  end

  def images
    @images ||= @product.photos.map do |image|
      ProductImageDrop.new image
    end
  end

  def type
    @product.product_type
  end

  def price_varies
    @price_varies ||= @product.variants.map(&:price).uniq.size > 1
  end

  def price_min
    price
  end

  def compare_at_price_varies
    @compare_at_price_varies ||= @product.variants.map(&:compare_at_price).uniq.size > 1
  end

  def compare_at_price_max
    @compare_at_price_max ||= @product.variants.map(&:compare_at_price).max
  end

  def compare_at_price_min
    @compare_at_price_min ||= @product.variants.map(&:compare_at_price).min
  end

  def description
    @product.body_html
  end

  def featured_image
    @featured_image ||= ProductImageDrop.new @product.photos.first unless @product.photos.empty?
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

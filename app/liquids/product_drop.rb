#encoding: utf-8
class ProductDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(product)
    @product = product
  end

  delegate :id, :handle, :title, :price, :vendor, :tags, to: :@product

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

  def available
    @product.published
  end

  def url
    #Rails.application.routes.url_helpers.product_path(@product)
    "/products/#{@product.handle}"
  end

  def type
    @product.product_type
  end

  def price_min
    price
  end

  def compare_at_price_max
    @product.variants.map(&:compare_at_price).max
  end

  def compare_at_price_min
    @product.variants.map(&:compare_at_price).min
  end

  def description
    @product.body_html
  end

  def featured_image
    @product.photos.first
  end

  def as_json(options = nil)
    {
      id: id,
      handle: handle,
      title: title,
      available: available,
      options: @product.options.map(&:name),
      variants: variants.as_json,
    }
  end
end

class ProductImageDrop < Liquid::Drop

  def initialize(image)
    @image = image
  end

  def version(size) #相当于method_missing
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

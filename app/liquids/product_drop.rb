#encoding: utf-8
class ProductDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(product)
    @product = product
  end

  def id
    @product.id
  end

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

  def title
    @product.title
  end

  def price
    @product.variants.map(&:price).min
  end

  def description
    @product.body_html
  end

  def featured_image
    @product.photos.first
  end

  def as_json(options={})
    result = {}
    keys = self.public_methods(false)
    keys.delete(:as_json)
    keys.inject(result) do |result, method|
      result[method] = self.send(method)
      result
    end
    result
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

end

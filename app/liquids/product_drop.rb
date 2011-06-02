#encoding: utf-8
class ProductDrop < Liquid::Drop

  def initialize(product)
    @product = product
  end

  def variants
    @product.variants.map do |variant|
      ProductVariantDrop.new variant
    end
  end

  def options
    @product.options.map do |option|
      ProductOptionDrop.new option
    end
  end

  def images
    [] #TODO:增加照片
  end

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

  #TODO: 完成上传照片后显示商品照片
  def featured_image
    "/images/admin/no-image.gif"
  end

end

class ProductImagesDrop < Liquid::Drop

  def initialize(image)
    @image = image
  end

end

class ProductOptionDrop < Liquid::Drop

  def initialize(option)
    @option = option
  end

end

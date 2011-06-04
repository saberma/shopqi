#encoding: utf-8
class LineItemDrop < Liquid::Drop

  def initialize(variant, quantity)
    @variant = variant
    @quantity = quantity.to_i
  end

  def id
    @variant.id
  end

  def variant
    ProductVariantDrop.new @variant
  end

  def product
    ProductDrop.new @variant.product
  end

  def title
    return product.title if product.variants.size == 1
    "#{product.title} - #{@variant.options.join('/')}"
  end

  def price
    @variant.price
  end

  def line_price
    quantity * price
  end

  def quantity
    @quantity
  end

  def grams
    @variant.weight
  end

  def sku
    @variant.sku
  end

  def vendor
    product.vendor
  end

  def requires_shipping
    @variant.requires_shipping
  end

  #def tax
  #end

end

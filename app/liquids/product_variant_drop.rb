#encoding: utf-8
class ProductVariantDrop < Liquid::Drop

  def initialize(variant)
    @variant = variant
  end

  def id
    @variant.id
  end

  def title
    @variant.options.join(' / ')
  end

  def price
    @variant.price
  end

  def compare_at_price
    @variant.compare_at_price
  end

  def available
    true
  end

  def inventory_management
    @variant.inventory_management
  end

  def inventory_quantity
    @variant.inventory_quantity
  end

  def weight
    @variant.weight
  end

  def sku
    @variant.sku
  end

  def option1
    @variant.option1
  end

  def option2
    @variant.option2
  end

  def option3
    @variant.option3
  end

  def options
    @variant.options
  end

  def requires_shipping
    @variant.requires_shipping
  end

  #def taxable
  #  @variant.taxable
  #end

  def as_json(options={})
    result = {}
    keys = self.public_methods(false)
    keys = keys - [:as_json, :options]
    keys.inject(result) do |result, method|
      result[method] = self.send(method)
      result
    end
    result
  end

end

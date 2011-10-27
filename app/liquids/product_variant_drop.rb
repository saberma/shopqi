#encoding: utf-8
class ProductVariantDrop < Liquid::Drop

  def initialize(variant)
    @variant = variant
  end

  delegate :id, :price, :compare_at_price, :weight, :inventory_management, :inventory_quantity, :sku, :option1, :option2, :option3, :options, :requires_shipping, to: :@variant

  def title
    @variant.options.join(' / ')
  end

  def available
    true
  end

  #def taxable
  #  @variant.taxable
  #end

  def as_json(options = nil)
    {
      id: id,
      option1: option1,
      option2: option2,
      option3: option3,
      available: available,
      title: title,
      price: price,
      compare_at_price: compare_at_price,
      weight: weight,
      sku: sku,
    }
  end

end

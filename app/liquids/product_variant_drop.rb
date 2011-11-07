#encoding: utf-8
class ProductVariantDrop < Liquid::Drop

  def initialize(variant)
    @variant = variant
  end

  delegate :id, :title, :price, :compare_at_price, :available, :weight, :inventory_management, :inventory_quantity, :sku, :option1, :option2, :option3, :options, :requires_shipping, to: :@variant

  #def taxable
  #  @variant.taxable
  #end

  def as_json(options = nil)
    @variant.shop_as_json
  end

end

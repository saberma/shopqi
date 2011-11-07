#encoding: utf-8
class LineItemDrop < Liquid::Drop
  extend ActiveSupport::Memoizable

  def initialize(session_line_item)
    @session_line_item = session_line_item
  end

  delegate :id, :title, :line_price, :price, :quantity, :sku, :grams, :requires_shipping, :vendor, to: :@session_line_item

  def variant
    ProductVariantDrop.new(@session_line_item.variant)
  end
  memoize :variant

  def product
    ProductDrop.new(@session_line_item.product)
  end
  memoize :product

end

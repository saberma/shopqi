#encoding: utf-8
class LineItemDrop < Liquid::Drop

  def initialize(session_line_item)
    @session_line_item = session_line_item
  end

  delegate :id, :title, :line_price, :price, :quantity, :sku, :grams, :requires_shipping, :vendor, to: :@session_line_item

  def variant
    @variant ||= ProductVariantDrop.new(@session_line_item.variant)
  end

  def product
    @product ||= ProductDrop.new(@session_line_item.product)
  end

end

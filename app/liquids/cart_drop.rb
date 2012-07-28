#encoding: utf-8
class CartDrop < Liquid::Drop

  def initialize(cart_hash = {})
    @cart_hash = cart_hash #Hash{variant_id: quantity}
  end

  delegate :item_count, :requires_shipping, :total_price, :total_weight, :note, :attributes, to: :session_cart

  def session_cart
    @session_cart ||= begin
      shop = @context['shop'].instance_variable_get('@shop')
      @session_cart = SessionCart.new(@cart_hash, shop)
    end
  end

  def items
    @items ||= session_cart.items.map do |session_line_item|
      LineItemDrop.new session_line_item
    end
  end

end

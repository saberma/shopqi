#encoding: utf-8
class CartDrop < Liquid::Drop

  def initialize(cart_hash = {})
    @cart_hash = cart_hash #Hash{variant_id: quantity}
  end

  def item_count
    @cart_hash.size
    #@cart_hash.values.map(&:to_i).sum
  end

  def items
    shop = @context['shop'].instance_variable_get('@shop')
    @items ||= @cart_hash.map do |item|
      variant_id = item.first
      quantity = item.second
      variant = shop.variants.find(variant_id)
      LineItemDrop.new variant, quantity
    end
  end

  # 只要有一个款式需要收货，则购物车需要收货地址
  def requires_shipping
    @items.any? do |line_item_drop|
      line_item_drop.variant.requires_shipping
    end
  end

  def total_price
    items.map do |line_item_drop|
      variant = line_item_drop.variant
      line_item_drop.quantity * variant.price
    end.sum
  end

  def total_weight
    items.map do |line_item_drop|
      line_item_drop.variant.weight
    end.sum
  end

  def note
  end

  def attributes
  end

end

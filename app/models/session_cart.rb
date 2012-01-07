#encoding: utf-8
class SessionCart # Session购物车
  extend ActiveSupport::Memoizable

  def initialize(cart_hash = {}, shop)
    @cart_hash = cart_hash #Hash{variant_id: quantity}
    @shop = shop
  end

  def item_count
    @cart_hash.size
    #@cart_hash.values.map(&:to_i).sum
  end

  def items
    @cart_hash.map do |variant_id, quantity|
      SessionLineItem.new variant_id, quantity, @shop
    end
  end
  memoize :items

  # 只要有一个款式需要收货，则购物车需要收货地址
  def requires_shipping
    items.any?(&:requires_shipping)
  end
  memoize :requires_shipping

  def total_price
    items.map(&:line_price).sum
  end
  memoize :total_price

  def total_weight
    items.map(&:grams).sum
  end
  memoize :total_weight

  def note
  end

  def attributes
  end

  def as_json(options = nil)
    {
      items: self.items,
      requires_shipping: self.requires_shipping,
      total_price: self.total_price,
      attributes: self.attributes,
      item_count: self.item_count,
      note: self.note,
      total_weight: self.total_weight
    }
  end

end

class SessionLineItem # Session购物车中商品款式
  extend ActiveSupport::Memoizable

  def initialize(variant_id, quantity, shop)
    @variant = shop.variants.find(variant_id)
    @quantity = quantity.to_i
    @product = @variant.product
  end

  delegate :id, :price, :sku, :requires_shipping, to: :@variant
  delegate :vendor, to: :@product

  def variant
    @variant
  end

  def product
    @product
  end

  def title
    @variant.name
  end
  memoize :title

  def line_price
    quantity * price
  end
  memoize :line_price

  def quantity
    @quantity
  end

  def grams # 单位:克
    (quantity * @variant.weight * 1000).to_i
  end
  memoize :grams

  #def tax
  #end

  def as_json(options = nil)
    {
      handle: @product.handle,
      line_price: self.line_price,
      requires_shipping: self.requires_shipping,
      price: self.price,
      title: self.title,
      url: "/products/#{@product.handle}",
      quantity: self.quantity,
      id: self.id,
      grams: self.grams,
      sku: self.sku,
      vendor: @product.vendor,
      image: @product.index_photo,
      variant_id: self.id
    }
  end
end

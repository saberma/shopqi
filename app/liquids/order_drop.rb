class OrderDrop < Liquid::Drop

  def initialize(order)
    @order = order
  end

  def id
    @order.id
  end

  def order_name
    @order.name
  end

  def created_at
    @order.created_at
  end

  def shop_name
    @order.shop.name
  end

  def to_liquid
    {
      'shop_name' => shop_name,
      'created_at' => created_at,
      'order_name' => order_name
    }
  end

end

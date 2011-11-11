#encoding: utf-8
class Shop::AccountController < Shop::AppController
  prepend_before_filter :authenticate_customer!
  skip_before_filter :must_has_theme

  #layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }
  expose(:orders) { current_customer.orders }
  expose(:order) do
    if params[:token]
      orders.where(token: params[:token]).first
    end
  end

  def index
    path = Rails.root.join 'app/views/shop/templates/customers/account.liquid'
    assign = template_assign('customer' => CustomerDrop.new(current_customer))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign('customers', assign))
    render text: html
  end

  def show_order
    path = Rails.root.join 'app/views/shop/templates/customers/order.liquid'
    assign = template_assign('order' => OrderDrop.new(order))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign('customers', assign))
    render text: html
  end
end

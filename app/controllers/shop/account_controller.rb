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
    path = theme.template_path('customers/account')
    path = Rails.root.join 'app/views/shop/templates/customers/account.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_account')
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end

  def show_order
    path = theme.template_path('customers/order')
    path = Rails.root.join 'app/views/shop/templates/customers/order.liquid' unless File.exist?(path)
    assign = template_assign('template' => 'customers_order', 'order' => OrderDrop.new(order))
    liquid_view = Liquid::Template.parse(File.read(path)).render(assign)
    assign.merge!('content_for_layout' => liquid_view)
    html = Liquid::Template.parse(layout_content).render(shop_assign(assign))
    render text: html
  end
end

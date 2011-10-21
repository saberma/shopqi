#encoding: utf-8
class Shop::AccountController < Shop::AppController
  prepend_before_filter :authenticate_customer!
  skip_before_filter :must_has_theme

  layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }
  expose(:orders) { shop.orders }
  expose(:order) do
    if params[:token]
      orders.where(token: params[:token]).first
    end
  end

  def index
  end

  def show_order
  end
end

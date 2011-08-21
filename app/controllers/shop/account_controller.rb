#encoding: utf-8
class Shop::AccountController < Shop::AppController
  prepend_before_filter :authenticate_customer!, only: [:index]
  layout 'shop/admin'
  expose(:shop) { Shop.at(request.host) }

  def index
    ap current_customer
  end
end

class Api::ShopsController < Api::AppController
  expose(:shop){ Shop.at(request.host) }

  def index
    render json: shop
  end
end

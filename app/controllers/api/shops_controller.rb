class Api::ShopController < ApplicationController
  expose(:shop){ Shop.at(request.host) }

  def index
    render json: shop
  end
end

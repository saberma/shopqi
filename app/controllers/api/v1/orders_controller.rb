# encoding: utf-8
module Api::V1
  class OrdersController < AppController

    def index
      @orders = shop.orders
    end

  end
end

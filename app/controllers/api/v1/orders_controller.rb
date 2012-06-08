# encoding: utf-8
module Api::V1
  class OrdersController < AppController
    doorkeeper_for :index, scopes: [:read_orders, :write_orders], unless: lambda { @api_client }

    def index
      @orders = shop.orders.page(page).per(per_page)
    end

  end
end

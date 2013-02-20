# encoding: utf-8
module Api::V1
  class OrdersController < AppController
    doorkeeper_for :index, :show, scopes: [:read_orders, :write_orders], unless: lambda { @api_client }
    FIELDS = [:financial_status, :fulfillment_status]

    def index
      conditions = {}
      FIELDS.each do |field|
        conditions[field] = params[field] unless params[field].blank?
      end
      @orders = shop.orders.where(conditions).page(page).per(per_page)
    end

    def show
      @order = shop.orders.find(params[:id])
    end

  end
end

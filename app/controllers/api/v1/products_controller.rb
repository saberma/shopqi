# encoding: utf-8
module Api::V1
  class ProductsController < AppController
    doorkeeper_for :index, :show, scopes: [:read_products, :write_products], unless: lambda { @api_client }

    def index
      @products = shop.products.page(page).per(per_page)
    end

    def show
      @product = shop.products.find(params[:id])
    end

  end
end

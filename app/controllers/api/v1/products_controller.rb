# encoding: utf-8
module Api::V1
  class ProductsController < AppController
    doorkeeper_for :index, scopes: [:read_products, :write_products], unless: lambda { @api_client }

    def index
      @products = shop.products.page(page).per(per_page)
    end

  end
end

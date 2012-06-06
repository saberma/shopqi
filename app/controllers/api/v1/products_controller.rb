# encoding: utf-8
module Api::V1
  class ProductsController < AppController

    def index
      @products = shop.products
    end

  end
end

# encoding: utf-8
module Api::V1
  class ProductsController < AppController

    def index
      @products = shop.products.reorder('id asc')
    end

  end
end

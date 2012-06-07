# encoding: utf-8
module Api::V1
  class ProductsController < AppController

    def index
      @products = shop.products.page(page).per(per_page)
    end

  end
end

# encoding: utf-8
module Api::V1
  class ProductVariantsController < AppController
    doorkeeper_for :update, scopes: [:write_products], unless: lambda { @api_client }

    def update
      @variant = shop.variants.find(params[:id])
      @variant.update_attributes params[:variant].except(:id)
      render :show
    end

  end
end

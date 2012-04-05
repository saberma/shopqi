#encoding: utf-8
class Admin::DiscountsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:discounts) { shop.discounts }
  expose(:discounts_json) { discounts.to_json }
  expose(:discount)

  def index
  end

  def create
    discount.save
    render json: discount
  end

  def destroy
    discount.destroy
    render json: discount
  end

  def update
    discount.save
    render json: discount
  end
end

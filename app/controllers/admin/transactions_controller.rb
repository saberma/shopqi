#encoding: utf-8
class TransactionsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout nil

  expose(:shop) { current_user.shop }
  expose(:orders) { shop.orders }
  expose(:order)
  expose(:transactions) { order.transactions }
  expose(:transaction)

  def create
    transaction.save
    render json: transaction.to_json
  end
end

class Api::CustomersController < Api::AppController
  expose(:shop){ Shop.at(request.host) }
  expose(:customers){
    shop.customers.limit(10)
  }

  def index
    render json: customers
  end

end

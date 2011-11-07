class Api::CustomersController < Api::AppController
  expose(:shop){ Shop.at(request.host) }
end

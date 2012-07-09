# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webhook do
  end

  factory :webhook_orders_fulfilled, parent: :webhook do
    event "orders/fulfilled"
    callback_url "http://express.shopqiapp.com"
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webhook do
    event "orders/fulfilled"
    callback_url "http://express.shopqiapp.com"
  end
end

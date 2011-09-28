# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :weight_based_shipping_rate do
    country { FactoryGirl.build(:country)}
    name '普通快递'
  end
end

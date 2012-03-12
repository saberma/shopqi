# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping do
    code '440000' # 广东
  end

  factory :shipping_china, parent: :shipping do
    code '000000'
  end
end

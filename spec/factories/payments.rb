# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :payment do
    message  "汇款至: xxxx-123-456"
    name  "邮局汇款"
  end
end

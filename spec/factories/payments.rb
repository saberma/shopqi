# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :payment do
    message  "汇款至: xxxx-123-456"
    name  "邮局汇款"
  end

  factory :payment_alipay, parent: :payment do
    message  ""
    name  "支付宝"
    key UUID.generate(:compact)
    partner '2398072190767748'
    account 'mahb45@gmail.com'
  end
end

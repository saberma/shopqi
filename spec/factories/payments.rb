# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :payment do
    message  "汇款至: xxxx-123-456"
    name  "邮局汇款"
  end

  factory :payment_alipay, parent: :payment do
    message  ""
    name ''
    payment_type_id 1 # KeyValues::PaymentType 支付宝
    account '2398072190767748'
    key UUID.generate(:compact)
    email 'mahb45@gmail.com'
    service ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER # 即时到帐
  end

  factory :payment_tenpay, parent: :payment do
    message  ""
    name ''
    payment_type_id 2 # KeyValues::PaymentType 财付通
    account '1872652336'
    key UUID.generate(:compact)
    email 'mahb45@gmail.com'
    service 'direct' # 即时到帐
  end
end

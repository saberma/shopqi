#encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :customer do
    password '666666'
  end

  factory :customer_saberma, parent: :customer do
    name '马海波'
    email 'mahb45@gmail.com'
    reset_password_token 'mWwSu97pAX6vLJtQbQ4y'
    addresses_attributes [
    { name: '马海波', country_code: 'CN', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888', zip: '517058' }]
  end

  factory :customer_liwh, parent: :customer do
    name '李卫辉'
    email 'liwh87@gmail.com'
    addresses_attributes [{
    name: '李卫辉', country_code: 'CN',province: '440000', city: '440300', district: '440305', address1: '311', phone: '13751042627'
  }]
  end
end

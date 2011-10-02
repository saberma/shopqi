#encoding: utf-8
FactoryGirl.define do
  factory :order do
    email "mahb45@gmail.com"
    shipping_address_attributes name: '马海波', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888'
  end

  factory :order_liwh, parent: :order do
    email "liwh87@gmail.com"
    shipping_address_attributes name: '李卫辉', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13751042627'
  end
end

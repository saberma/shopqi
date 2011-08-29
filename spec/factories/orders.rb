#encoding: utf-8
Factory.define :order do |f|
  f.email "mahb45@gmail.com"
  f.billing_address_attributes name: '马海波', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888'
  f.shipping_address_attributes name: '马海波', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888'
end

Factory.define :order_liwh, parent: :order do |f|
  f.email "liwh87@gmail.com"
  f.billing_address_attributes name: '李卫辉', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13751042627'
  f.shipping_address_attributes name: '李卫辉', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13751042627'
end

#encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :customer do |f|
end

Factory.define :customer_saberma, parent: :customer do |f|
  f.name '马海波'
  f.email 'mahb45@gmail.com'
  f.addresses_attributes [
    { name: '马海波', country_code: 'CN', province: '440000', city: '440300', district: '440305', address1: '311', phone: '13928452888' }]
end

Factory.define :customer_liwh, parent: :customer do |f|
  f.name '李卫辉'
  f.email 'liwh87@gmail.com'
  f.addresses_attributes [{
    name: '李卫辉', country_code: 'CN',province: '440000', city: '440300', district: '440305', address1: '311', phone: '13751042627'
  }]
end

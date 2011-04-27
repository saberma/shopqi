# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |u|
  u.email 'admin@shopqi.com'
  u.shop_attributes permanent_domain: 'shop', name: '测试商店'
  u.password '666666'
  u.password_confirmation '666666'
end

Factory.define :user_liwh, :parent => :user do |u|
  u.email 'liwh87@shopqi.com'
  u.name 'liwh'
end

Factory.define :user_admin, :parent => :user do |u|
  u.email 'admin@shopqi.com'
  u.name 'admin'
end

Factory.define :user_saberma, :parent => :user_admin do |u|
  u.email 'mahb45@gmail.com'
  u.name 'saberma'
end

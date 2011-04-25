# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |u|
  u.password '666666'
  u.password_confirmation '666666'
end

Factory.define :user_liwh, :parent => :user do |u|
  u.email 'liwh87@shopqi.com'
  u.shop  { Factory(:shop_liwh)}
end

Factory.define :user_admin, :parent => :user do |u|
  u.shop_name '测试商店'
  u.shop_permanent_domain 'shop'
  u.email 'admin@shopqi.com'
end

Factory.define :user_saberma, :parent => :user_admin do |u|
  u.email 'mahb45@gmail.com'
end

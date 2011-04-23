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

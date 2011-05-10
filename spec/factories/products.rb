# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :product do |f|
end

Factory.define :iphone4, :parent => :product do |f|
  f.title "苹果iphone 4手机"
  f.description "iphone 4是一款基于WCDMA制式的3G手机"
  f.price 6999.00
  f.market_price 4899.00
  f.vendor "Apple"
end

Factory.define :psp, :parent => :product do |f|
  f.title "psp"
  f.description ""
  f.price 999.00
  f.market_price 1299.00
end

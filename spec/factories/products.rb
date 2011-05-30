# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :product do |f|
  f.variants_attributes [
    {price: 0.0, weight: 0.0}
  ]
end

Factory.define :iphone4, parent: :product do |f|
  f.title "iphone4"
  f.body_html "iphone 4是一款基于WCDMA制式的3G手机"
  f.product_type "手机"
  f.vendor "Apple"
end

Factory.define :psp, parent: :product do |f|
  f.title "psp"
  f.body_html ""
  f.product_type "游戏机"
  f.vendor "Sony"
end

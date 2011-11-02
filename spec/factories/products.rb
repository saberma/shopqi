# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :product do
    variants_attributes [
    {price: 0.0, weight: 0.0}
  ]
  end

  factory :iphone4, parent: :product do
    title "iphone4"
    body_html "iphone 4是一款基于WCDMA制式的3G手机"
    product_type "手机"
    vendor "Apple"
    variants_attributes [
    {price: 3000, compare_at_price: 3500, weight: 2.9}
  ]
  end

  factory :psp, parent: :product do
    title "psp"
    body_html ""
    product_type "游戏机"
    vendor "Sony"
  end
end

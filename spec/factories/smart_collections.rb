# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :smart_collection do |f|
  f.title "低价商品"
  f.body_html "低价商品"
end

Factory.define :smart_collection_low_price, parent: :smart_collection do |f|
  f.rules_attributes [
    {column: 'variants_price', relation: 'less_than', condition: 100}
  ]
end

Factory.define :smart_collection_high_price, parent: :smart_collection do |f|
  f.rules_attributes [
    {column: 'variants_price', relation: 'greater_than', condition: 1000}
  ]
end

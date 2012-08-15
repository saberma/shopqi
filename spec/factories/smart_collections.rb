# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :smart_collection do
    title "低价商品"
    body_html "低价商品"
  end

  factory :smart_collection_default, parent: :smart_collection do
    rules_attributes [
    {column: 'title', relation: 'equals', condition: ''}
  ]
  end

  factory :smart_collection_low_price, parent: :smart_collection do
    rules_attributes [
    {column: 'variants_price', relation: 'less_than', condition: 100}
  ]
  end

  factory :smart_collection_high_price, parent: :smart_collection do
    rules_attributes [
    {column: 'variants_price', relation: 'greater_than', condition: 1000}
  ]
    end
end

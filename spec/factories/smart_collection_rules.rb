# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :smart_collection_rule do |f|
  f.column "MyString"
  f.relation "MyString"
  f.condition "MyString"
end
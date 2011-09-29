# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :theme do
    load_preset "MyString"
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :webhook do
      event "MyString"
      callback_url "MyString"
    end
end

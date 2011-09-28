# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    session_id { UUID.generate(:compact) }
  end
end

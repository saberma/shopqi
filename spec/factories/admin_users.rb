# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
      email 'admin@shopqi.com'
      password '666666'
      password_confirmation '666666'
    end
end

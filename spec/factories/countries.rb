# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
    code 'HK'
  end

  factory :country_china,parent: :country do
    code 'CN'
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :link do
    title "ShopQi"
    link_type "http"
    subject_handle nil
    subject_params nil
    url "http://shopqi.com"
    end
end

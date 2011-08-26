# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :link do |f|
  f.title "ShopQi"
  f.link_type "http"
  f.subject_handle nil
  f.subject_params nil
  f.url "http://shopqi.com"
end

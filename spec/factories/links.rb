# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :link do |f|
  f.title "ShopQi"
  f.link_type "http"
  f.subject_id nil
  f.subject_params nil
  f.subject "http://shopqi.com"
end

# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :weight_based_shipping_rate do |f|
  f.country { Factory.build(:country)}
  f.name '普通快递'
end

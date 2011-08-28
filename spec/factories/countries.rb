# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :country do |f|
  f.code 'HK'
end

Factory.define :country_china,parent: :country do |f|
  f.code 'CN'
end

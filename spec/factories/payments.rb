# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :payment do |f|
  f.message  "汇款至: xxxx-123-456"
  f.name  "邮局汇款"
end

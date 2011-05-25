# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :blog do |f|
  f.shop { Factory.build(:shop_liwh) }
  f.title '博客1'
  f.commentable true
  f.handle 'blog1'
end

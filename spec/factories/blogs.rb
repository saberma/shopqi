# encoding: utf-8
Factory.define :blog do |f|
  f.shop { Factory.build(:shop_liwh) }
  f.title '博客1'
  f.commentable true
  f.handle 'blog1'
end

Factory.define :welcome, parent: :blog do |f|
  f.title '欢迎'
  f.handle 'welcome'
end

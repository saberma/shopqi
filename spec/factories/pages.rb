# encoding: utf-8
Factory.define :page do |f|
  f.title "MyString"
  f.body_html "MyString"
end

Factory.define 'about-us', parent: :page do |f|
  f.title "关于我们"
  f.body_html "关于我们"
end

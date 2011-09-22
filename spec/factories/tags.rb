# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :tag do |f|
  f.name "游戏机"
end

Factory.define :tag_phone, parent: :tag  do |f|
  f.name "手机"
end

Factory.define :tag_computer, parent: :tag do |f|
  f.name "电脑"
end

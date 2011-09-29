# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    name "游戏机"
  end

  factory :tag_phone, parent: :tag  do
    name "手机"
  end

  factory :tag_computer, parent: :tag do
    name "电脑"
  end
end

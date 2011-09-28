# encoding: utf-8
FactoryGirl.define do
  factory :page do
    title "MyString"
    body_html "MyString"
  end

  factory 'about-us', parent: :page do
    title "关于我们"
    body_html "关于我们"
  end
end

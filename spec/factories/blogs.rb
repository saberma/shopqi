# encoding: utf-8
FactoryGirl.define do
  factory :blog do
    title '博客1'
    commentable 'no'
    handle 'blog1'
  end

  factory :welcome, parent: :blog do
    title '欢迎'
    handle 'welcome'
  end
end

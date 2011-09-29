# encoding: utf-8
FactoryGirl.define do
  factory :link_list do
    title "链接"
   end

  factory :link_list_with_links, :parent => :link_list do
    title "热门品牌"
    links {[
    FactoryGirl.build(:link, :title => 'IBM'),
    FactoryGirl.build(:link, :title => '华硕')
     ]}
    end
end

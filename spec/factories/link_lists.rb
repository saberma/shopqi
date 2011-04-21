# encoding: utf-8
Factory.define :link_list do |f|
  f.title "链接"
end

Factory.define :link_list_with_links, :parent => :link_list do |f|
  f.title "热门品牌"
  f.links {[
    Factory.build(:link, :title => 'IBM'),
    Factory.build(:link, :text => '华硕')
  ]}
end

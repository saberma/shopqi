# encoding: utf-8
class LinkType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => '博客', :code => 'blog'},
    {:id => 2, :name => '商店首页', :code => 'frontpage'},
    {:id => 3, :name => '商品列表', :code => 'collection'},
    {:id => 4, :name => '指定页面', :code => 'page'},
    {:id => 5, :name => '指定商品', :code => 'product'},
    {:id => 6, :name => '查询页面', :code => 'search'},
    {:id => 7, :name => '其他网址', :code => 'http'}
  ]
end


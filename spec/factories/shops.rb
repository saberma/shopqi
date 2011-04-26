# encoding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :shop do |u|
  u.name '测试商店'
  u.domain 'http://example.com'
  u.permanent_domain 'shop'
  u.title '快乐购物'
  u.province '广东省'
  u.city '深圳市'
  u.address '世界之窗'
  u.keywords '衣服 鞋子'
  u.public 1
  u.theme 'shopqi'
end

Factory.define :shop_liwh, :parent => :shop do |u|
  u.name '陶瓷商店'
  u.domain 'http://robielee.me'
  u.permanent_domain 'liwh'
  u.email 'liwh87@gmail.com'
  u.phone '400-800-88000'
  u.products {[
    Factory.build(:iphone4)
  ]}
end


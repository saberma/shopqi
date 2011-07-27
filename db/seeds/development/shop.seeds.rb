# encoding: utf-8
# 加载三个商店，方便在开发环境中进行测试

Shop.destroy_all

shopqi = User.create!(
  shop_attributes: { name:"shopqi", domains_attributes: [{subdomain: 'shopqi', domain: ".myshopqi.com"}] },
  email: "admin@shopqi.com",
  password: "666666",
  name: "admin"
)

saberma = User.create!(
  shop_attributes: { name: "商城", domains_attributes: [{subdomain: 'saberma', domain: ".myshopqi.com"}] },
  email: "mahb45@gmail.com",
  password: "666666",
  name: "saberma"
)

liwh= User.create!(
  shop_attributes: { name: "鞋子", domains_attributes: [{subdomain: 'liwh', domain: ".myshopqi.com"}] },
  email: "liwh87@gmail.com", password: "666666", name: "liwh"
)

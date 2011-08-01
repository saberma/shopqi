# encoding: utf-8
# 加载三个商店，方便在开发环境中进行测试

Shop.destroy_all

domain = Setting.store_host
shopqi = User.create!(
  shop_attributes: {
    name:"shopqi",
    domains_attributes: [{subdomain: 'shopqi', domain: domain}],
    theme_attributes: { theme_id: Theme.default.id }
  },
  email: "admin@shopqi.com",
  password: "666666",
  name: "admin"
)

saberma = User.create!(
  shop_attributes: {
    name: "商城",
    domains_attributes: [{subdomain: 'saberma', domain: domain}],
    theme_attributes: { theme_id: Theme.default.id }
  },
  email: "mahb45@gmail.com",
  password: "666666",
  name: "saberma"
)

liwh= User.create!(
  shop_attributes: {
    name: "鞋子",
    domains_attributes: [{subdomain: 'liwh', domain: domain}],
    theme_attributes: { theme_id: Theme.default.id }
  },
  email: "liwh87@gmail.com",
  password: "666666",
  name: "liwh"
)

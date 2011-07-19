# encoding: utf-8
# 加载三个商店，方便在开发环境中进行测试

Shop.destroy_all

liwh= User.create!(
  shop_attributes: { name: "鞋子", permanent_domain: "liwh" },
  email: "liwh87@gmail.com", password: "666666", name: "liwh"
)

saberma = User.create!(
  shop_attributes: { name: "商城", permanent_domain: "saberma" },
  email: "mahb45@gmail.com",
  password: "666666",
  name: "saberma"
)

shopqi = User.create!(
  shop_attributes: { name:"shopqi", permanent_domain: "shopqi" },
  email: "admin@shopqi.com",
  password: "666666",
  name: "admin"
)

# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
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

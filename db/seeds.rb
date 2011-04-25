# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Shop.delete_all
User.delete_all
liwh= User.create(:shop_name => "鞋子",:shop_permanent_domain => "test",:email => "liwh87@gmail.com",:password => "666666",:name => "liwh")
saberma = User.create(:shop_name => "商城",:shop_permanent_domain => "shop",:email => "mahb45@gmail.com",:password => "666666",:name => "saberma")
shopqi = User.create(:shop_name => "shopqi",:shop_permanent_domain => "shopqi",:email => "admin@shopqi.com",:password => "666666",:name => "admin")

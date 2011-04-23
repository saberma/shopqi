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
u= User.create(:shop_name => "鞋子",:shop_permanent_domain => "test",:email => "liwh87@gmail.com",:password => "666666",:name => "liwh")

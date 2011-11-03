# encoding: utf-8
# 此文件用于批量生成顾客、订单等记录，方便截图演示
# rails runner script/data.rb

return unless Rails.env.development?

def random_district # 随机取地区
  district = District.list
  province = district[(rand * district.size).floor].last
  district = District.list(province)
  city = district[(rand * district.size).floor].last
  district = District.list(city)
  district = district[(rand * district.size).floor].last
  {province: province, city: city, district: district}
end

def random_product(products) # 随机商品
  index = (rand * products.size).floor
  products[index]
end

def random_shipping_rate(shipping_rates) # 随机配送方式
  index = (rand * shipping_rates.size).floor
  shipping_rates[index]
end

names = ["陈民修", "徐小姐", "李展心", "栾家慧", "陈思祥", "陈景皓", "杨佳以", "陈先生", "赖廷麟", "吴思芸", "黄云莲", "李昆生", "夏建宇", "骆志杰", "宗雅婷", "王家铭", "洪彦玫", "许祖雨", "游芝丹", "张丞桂", "张宗宪", "萧瑶季", "吴承坤", "陈永圣", "郑佩颖", "傅怡廷", "张绍海", "杨骏吉", "王柏廷", "郭翠哲", "蓝惠珠", "陈怡珊", "陈健珠", "高尹芷", "林俊文", "童原英", "陈珮元", "钟初骏", "李慧玲", "林家豪", "蔡明佳", "张志香", "陈慧齐", "许育如", "骆怡婷", "刘嘉玲", "张法佳", "赵韵如", "边语佳", "钱惠如"] # http://j.mp/p8u676 生成后通过translate.g.cn转化为简体

shop = Shop.where(name: 'myshopqi').first # 一定要限定商品
products = shop.products
shipping_rates = shop.countries.where(code: 'CN').first.weight_based_shipping_rates # 根据国家取配送方式

names.each do |name|
  pinyin = Pinyin.t(name).gsub(' ','')
  email = "#{pinyin}@gmail.com"
  address = random_district
  attrs = {name: name, email: email, addresses_attributes:[address]}
  customer = shop.customers.create attrs

  phone = "139#{Random.new.rand(10000000..99999999)}"
  address_attrs = {name: name, address1: '311', phone: phone}.merge address
  order_attrs = {email: email,  shipping_address_attributes: address_attrs}
  Random.new.rand(1..3).times do # 生成订单
    order = shop.orders.build order_attrs
    3.times do # 订单商品
      variant = random_product(products).variants.first
      price = Random.new.rand(10..50)
      quantity = Random.new.rand(1..20)
      order.line_items.build product_variant: variant, price: price, quantity: quantity
    end
    order.shipping_rate = random_shipping_rate(shipping_rates).shipping_rate # 配送方式
    order.save
    order.financial_status = :pending # 显示首次订单(订单有效)
    order.save
  end
end

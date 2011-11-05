# encoding: utf-8
# 加载两个商店，方便在开发环境中进行测试
# shopqi用于测试新手入门，即不含任何商品、顾客信息，以 admin@shopqi.com 用户登录
# myshopqi用于测试老用户，预含6件商品、2条顾客信息，以 admin@myshopqi.com 用户登录

Theme.destroy_all
Shop.destroy_all

Factory :theme_woodland_slate

domain = Setting.store_host
shopqi = User.create!(
  shop_attributes: {
    name:"shopqi",
    email: 'admin@shopqi.com',
    domains_attributes: [{subdomain: 'shopqi', domain: domain}],
    themes_attributes: [{ theme_id: Theme.default.id }]
  },
  email: "admin@shopqi.com",
  password: "666666",
  name: "admin"
).shop

myshopqi = User.create!(
  shop_attributes: {
    name:"myshopqi",
    email: 'admin@myshopqi.com',
    domains_attributes: [{subdomain: 'myshopqi', domain: domain}],
    themes_attributes: [{ theme_id: Theme.default.id}]
  },
  email: "admin@myshopqi.com",
  password: "666666",
  name: "admin"
).shop

# 商品
product_description = %q{
<p>这是一个商品.</p>
<p>您在这里看到的文字是商品的描述。每个商品都有价格、重量、照片和说明。您可以打开后台管理的<a href="/admin/products">商品标签页面</a>修改商品说明或者新增一个商品。</p>
<p>当您已经掌握商品的新增和修改，您会希望商品显示在您的ShopQi网站上。只需要完成以下两个步骤：</p>
<p>首先，您需要将您的商品添加到集合中。集合是把商品组织在一起的简单方法。如果您打开后台管理的<a href="/admin/custom_collections">集合标签页面</a>，您就可以开始新增集合，并把商品添加进去。</p>
<p>然后，您需要为商店的导航菜单新增一个链接，指向您的集合。您可以打开后台管理的<a href="/admin/link_lists">链接标签</a>，并点击“新增链接”。</p>
<p>一切顺利!</p>
}
frontpage_collection = myshopqi.custom_collections.where(handle: 'frontpage').first
1.upto(6) do |i|
  product = myshopqi.products.create title: "示例商品#{i}", handle: "example-#{i}", body_html: product_description, product_type: '手机', vendor: 'ShopQi'
  product.collections << frontpage_collection
  product.save
end

# 默认顾客
myshopqi.customers.create [
  {
    name: '李卫辉', email: 'liwh87@gmail.com', note: '默认顾客',password: '666666',
    addresses_attributes: [{ name: '李卫辉', province: '440000', city: '440300', district: '440305', address1: '科技园南区311', phone: '13751042627', zip: '517058' }]
  }, {
    name: '马海波', email: 'mahb45@gmail.com', note: '默认顾客',password: '666666',
    addresses_attributes: [{ name: '马海波', province: '440000', city: '440300', district: '440305', address1: '科技园南区311', phone: '13928452888', zip: '517058' }]
  }
]

# 默认顾客分组
myshopqi.customer_groups.create [
  { name: '接收营销邮件', query: 'accepts_marketing:yes:接收营销邮件:是' }                         ,
  { name: '潜在顾客'    , query: 'last_abandoned_order_date:last_month:放弃订单时间:在最近一个月' },
  { name: '多次消费'    , query: 'orders_count_gt:1:订单数 大于:1' }                               ,
]

#默认api_client,用于测试shopqi_api
myshopqi.api_clients.create(
  api_key:  "a"*32,
  password: "b"*32,
  shared_secret: "c"*32
)

myshopqi.launch!

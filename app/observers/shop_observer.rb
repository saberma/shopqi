# encoding: utf-8
# 初始化子记录
class ShopObserver < ActiveRecord::Observer

  def after_create(shop)
    # 集合
    frontpage_collection = shop.custom_collections.create title: '首页商品', handle: 'frontpage'

    # 页面
    welcome_page = shop.pages.create title: '欢迎', handle: 'frontpage', body_html: %q{
<p><strong>恭喜！您已成功发布网上商店！</strong></p

<p>这是您的网店首页，当您的顾客进入网店时将看到这里的内容。您可以重新修改此内容。</p>

<p>请您进入<a href="/admin">后台管理</a>，开始为您的网店新增商品。</p>

<p>ShopQi团队。</p>
    }
    about_us_page = shop.pages.create title: '关于我们', handle: 'about-us', body_html: %q{
<p>商店的<strong>关于我们</strong>页面是非常重要的，因此顾客将通过访问此页面来了解您的商店。此页面的内容可以包括以下部分：</p>
<ul>
<li>介绍您的公司</li>
<li>商店主要销售商品类型</li>
<li>公司地址</li>
</ul>
<p>请进入后台管理的<a href="/admin/pages">页面&博客</a>，修改此页面内容。</p>
    }

    # 主菜单(首页、商品列表、关于我们)，页脚(查询、关于我们)
    main_menu = shop.link_lists.create title: '主菜单', handle: 'main-menu', system_default: true
    main_menu.links.create title: '首页', link_type: 'frontpage', url: '/', position: 1
    main_menu.links.create title: '商品列表', link_type: 'http', url: '/collections/all', position: 2
    main_menu.links.create title: '关于我们', link_type: 'page', url: "/pages/#{about_us_page.handle}", subject_handle: about_us_page.handle, position: 3
    footer = shop.link_lists.create title: '页脚', handle: 'footer', system_default: true
    footer.links.create title: '查询', link_type: 'search', url: '/search', position: 1
    footer.links.create title: '关于我们', link_type: 'page', url: "/pages/#{about_us_page.handle}", subject_handle: about_us_page.handle, position: 2

    shop.blogs.create title: '最新动态', handle: 'news', commentable: 'no' # 博客(最新动态)

    shop.update_attributes password_enabled: true, password: Random.new.rand(1000..9999) # 前台商店密码保护，用户完成指引任务启用商店会清除

    shop.tasks.create [ # 新手指引任务
      {name: :add_product},
      {name: :customize_theme},
      {name: :add_content},
      {name: :setup_payment_gateway},
      {name: :setup_taxes},
      {name: :setup_shipping},
      {name: :setup_domain},
      {name: :launch},
    ]

    c = shop.countries.build(code: 'CN') #默认创建中国地区
    c.weight_based_shipping_rates.build name: '普通快递' #并创建默认的快递方式
    c.save

    # 创建各个邮件样板
    KeyValues::Mail::Type.all.each do |type|
      code = type.code.to_sym
      title = Setting.templates.email.send(code).title
      body  = Setting.templates.email.send(code).body
      shop.emails.create title: title,mail_type: code , body: body
    end

    # 预先生成consumer access_token(不需要用户手动授权主题应用)，用于主题商店切换主题
    client = OAuth2::Model::Client.find_by_client_id(Theme.client_id)
    author = shop.oauth2_authorizations.build client: client
    #author = OAuth2::Model::Authorization.new owner: shop, client: client
    author.access_token = OAuth2::Model::Authorization.create_access_token
    author.save
    shop.oauth2_consumer_tokens.create client_id: client.client_id, access_token: author.access_token
  end

end

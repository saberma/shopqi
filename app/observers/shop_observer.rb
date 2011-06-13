# encoding: utf-8
# 初始化子记录
class ShopObserver < ActiveRecord::Observer

  def after_create(shop)
    # 集合
    frontpage_collection = shop.custom_collections.create title: '首页商品', handle: 'frontpage'
    # 商品
    product_description = %q{
<p>这是一个商品.</p>
<p>您在这里看到的文字是商品的描述。每个商品都有价格、重量、照片和说明。您可以打开后台管理的<a href="/admin/products">商品标签页面</a>修改商品说明或者新增一个商品。</p>
<p>当您已经掌握商品的新增和修改，您会希望商品显示在您的ShopQi网站上。只需要完成以下两个步骤：</p>
<p>首先，您需要将您的商品添加到集合中。集合是把商品组织在一起的简单方法。如果您打开后台管理的<a href="/admin/custom_collections">集合标签页面</a>，您就可以开始新增集合，并把商品添加进去。</p>
<p>然后，您需要为商店的导航菜单新增一个链接，指向您的集合。您可以打开后台管理的<a href="/admin/link_lists">链接标签</a>，并点击“新增链接”。</p>
<p>一切顺利!</p>
    }
    1.upto(6) do |i|
      product = shop.products.create title: "示例商品#{i}", handle: "example-#{i}", body_html: product_description, product_type: '手机', vendor: 'ShopQi'
      product.collections << frontpage_collection
      product.save
    end

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
    main_menu.links.create title: '首页', link_type: 'frontpage', subject: '/', position: 1
    main_menu.links.create title: '商品列表', link_type: 'http', subject: '/collections/all', position: 2
    main_menu.links.create title: '关于我们', link_type: 'page', subject_id: about_us_page.id, position: 3
    footer = shop.link_lists.create title: '页脚', handle: 'footer', system_default: true
    footer.links.create title: '查询', link_type: 'search', position: 1
    footer.links.create title: '关于我们', link_type: 'page', subject_id: about_us_page.id, position: 2

    # 博客(最新动态)
    shop.blogs.create title: '最新动态', handle: 'latest-news'
    # 创建各个邮件样板
    shop.emails.create title: '{{shop.name}}',mail_type: KeyValues::Mail::Type.first.code, body: '{{shop.name}}'
  end

end

# encoding: utf-8
# 初始化子记录
class ShopObserver < ActiveRecord::Observer

  def after_create(shop)
    # 页面
    welcome = shop.pages.create title: '欢迎', handle: 'frontpage', body_html: %q{
      恭喜！您已成功发布网上商店！

      这是您的网店首页，当您的顾客进入网店时将看到这里的内容。您可以重新修改此内容。

      请您进入后台管理，开始为您的网店新增商品。

      ShopQi团队。
    }
    about_us = shop.pages.create title: '关于我们', handle: 'about-us', body_html: %q{
      商店的[关于我们]页面是非常重要的，因此顾客将通过访问此页面来了解您的商店。此页面的内容可以包括以下部分：

      介绍您的公司
      商店主要销售商品类型
      公司地址

      请进入后台管理的页面&博客，修改此页面内容。
    }

    # 主菜单(首页、商品列表、关于我们)，页脚(查询、关于我们)
    main_menu = shop.link_lists.create title: '主菜单', handle: 'main-menu', system_default: true
    main_menu.links.create title: '首页', link_type: 'frontpage', subject: '/', position: 1
    main_menu.links.create title: '商品列表', link_type: 'http', subject: '/collections/all', position: 2
    main_menu.links.create title: '关于我们', link_type: 'page', subject_id: about_us.id, position: 3
    footer = shop.link_lists.create title: '页脚', handle: 'footer', system_default: true
    footer.links.create title: '查询', link_type: 'search', position: 1
    footer.links.create title: '关于我们', link_type: 'page', subject_id: about_us.id, position: 2
  end

end

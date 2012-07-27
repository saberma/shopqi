## ShopQi [![维护中](http://stillmaintained.com/saberma/shopqi.png)](http://stillmaintained.com/saberma/shopqi) [![测试結果](https://secure.travis-ci.org/saberma/shopqi.png)](http://travis-ci.org/saberma/shopqi)

## English README

ShopQi is based on Rails3.2, include all the features of e-commerce.

Please feel free to [contact me](mailto:mahb45@gmail.com) if you have any questions.

### Installation

*Requirement*

1. [PostgreSQL](http://www.postgresql.org/download)
2. [Redis](http://redis.io/download)

*Installation*

    $ bundle
    $ bundle exec rake shopqi:bootstrap

### Usage

*Start the server*

    $ bundle exec unicorn_rails -p 4000 -c config/development.unicorn.conf.rb

*Open the browser*

http://www.lvh.me:4000

**DO NOT use localhost, use lvh.me intead.**


## 中文说明(Chinese README)

ShopQi 基于 Rails3.2 开发, 覆盖电子商务所有功能，包括

有任何问题或建议请[联系我](mailto:mahb45@gmail.com).

*基本功能*

* 商品，含商品分类、库存，自动生成商品图片各种规格的缩略图
* 顾客，含顾客分组，统计消费情况
* 订单，含发货处理
* 支付，整合支付宝，财付通等支付网关
* 物流，制定物流及快递规则，如发货到广东1kg以内的商品费用为10元
* 搜索，支持对商品、顾客、订单等进行全文检索

*商店外观美化功能*

* 外观，支持100%定制，提供在线定制和版本控制；支持多套外观方案，如圣诞节专题外观
* 模板，支持通过切换模板改变外观、模板可以含有多个不同的颜色预设方案
* 导航，用于维护商店所有链接，如商店底部菜单一般会显示"关于我们"、"联系我们"等

*通知提醒*

* 邮件，可以设置下单、发货等操作发送邮件通知管理员、顾客，邮件内容可以定制
* 回调，即 Webhook，下单、发货等事件发生时支持向外部应用发送数据，可用于整合内部系统

*附加功能*

* 博客，用于发布时效性的文章，如"年中庆全场免运费"等
* 页面，用于维护长期有效的信息，如"关于我们"、"支付流程"等
* 域名，支持绑定到顶级域名

*扩展能力*

* 支持 OAuth2 应用认证
* 提供商品、订单等 API
* 提供 API 调用 Ruby 客户端 [shopkit](http://github.com/saberma/shopkit)
* 提供 Rails 应用 Engine [shopqi-app](http://github.com/saberma/shopqi-app)，及其示例应用 [shopqi-app-example](http://github.com/saberma/shopqi-app-example)
* 提供 Rails 应用 Engine(支持 Webhook 回调) [shopqi-app-webhook](http://github.com/saberma/shopqi-app-webhook)

### 安装

*要求*

1. [PostgreSQL](http://www.postgresql.org/download)
2. [redis](http://redis.io/download)

*安装*

    $ bundle
    $ bundle exec rake shopqi:bootstrap

### 使用

*启动应用服务器*

    $ bundle exec unicorn_rails -p 4000 -c config/development.unicorn.conf.rb

*浏览*

http://www.lvh.me:4000

**注意不要使用 localhost 来访问**

### 反馈

[有任何问题点这里](https://github.com/saberma/shopqi/issues)
[![提交问题](http://i.imgur.com/K8vsw.gif)](https://github.com/saberma/shopqi/issues)


## License

[GNU  Affero GPL 3](http://www.gnu.org/licenses/agpl-3.0.html)

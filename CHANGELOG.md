## v0.1.5 / 2011-12-11 (8)

### 功能(4):

1. 顾客可以提交意见表单[saberma] #347
2. 增加博客文章comments_enabled模板属性[saberma] #346
3. 增加模板过滤器camelize[saberma] #345
4. 绑定顶级域名访问商店不使用https协议[saberma] #344

### 缺陷(4):

1. 主题商店的链接要加no-follow[saberma] #339
2. 官网用户登录页面jquery.js报404[saberma] #342
3. 顾客页面，新增空地址存在问题[liwh] #349
4. wiki，标题为中文时，编码有问题[liwh] #338


## v0.1.4 / 2011-12-04 (18)

### 功能(6):

1. 商店附件文件的asset_host要使用http协议[saberma] #333
2. 地址为人工输入项[saberma] #322
3. 上传图片处，对非图片文件上传，未加页面提醒。[saberma] #321
4. 重构用户列表，用backbone 形式替换[liwh] #318
5. 用户安装主题时判断权限[liwh] #314
6. 后台管理对用户权限进行控制[liwh] #313

### 缺陷(12):

1. 商店后台偶尔出现无法登录的情况[saberma] #291
2. 选择支付方式确认购买商品后显示页面不存在[saberma] #332
3. data目录下主题附件目录链接到public时不能使用release_path[saberma] #330
4. 访问/robots.txt后台报错[saberma] #329
5. 商品厂商修改不生效[saberma] #328
6. 在设置->email&提醒处，删除邮箱后，提示找不到页面。[saberma] #327
7. 增加商品报500错误[saberma] #319
8. 支付网关处，使用普通支付功能时提醒有问题。[saberma] #324
9. 使用忘记密码功能时，没有正常转到密码重置链接。[saberma] #323
10. 官网后台管理修改商店时报邮箱格式不正确[saberma] #320
11. 在官网输入用户名密码登录仍会跳到商店的登录页面[saberma] #326
12. 处理权限处头像显示[liwh] #336


## v0.1.3 / 2011-11-27 (23)

### 功能(11):

1. smtp发送邮箱改为可配置[saberma] #312
2. 顾客购买商品支付后要能看到支付成功的提示[saberma] #304
3. 后台管理支付时可以选择支付宝接口类型[saberma] #302
4. 官网、主题商店等使用不同的robots[saberma] #301
5. 百度采集时不使用https[saberma] #299
6. 商店菜单支持下拉二级菜单[saberma] #252
7. 新增主题时要加校验[saberma] #253
8. 商店后台管理帐号设置关闭商店功能没有实现删除商店[liwh] #283
9. sku数量超过商店限制后不能再新增商品和款式[liwh] #282
10. 商店帐户到期后不能再访问[liwh] #281
11. 完善用户权限管理，细化用户权限[liwh] #192

### 缺陷(12):

1. 商品详情图片未显示[saberma] #317
2. 给body加字体，要不然ie下字体显得特瘦窄[saberma] #286
3. 启用商店后商品列表仍显示指南[saberma] #310
4. 注册页面电话、手机验证码样式有问题[saberma] #309
5. 支付成功后后台管理订单详情未显示正确的支付方式[saberma] #306
6. 商店购买商品支付时出现错误[saberma] #303
7. 注册失败时商店目录没有删除[saberma] #292
8. 官网后台找不到active_admin的js文件[saberma] #298
9. 各主题 加上顾客注册链接[saberma] #297
10. 商品价格没有与款式同步更新[saberma] #300
11. 查询分页问题[liwh] #296
12. NoMethodError in ActiveAdmin::ShopsController#state  undefined method `index_photo' for nil:NilClass[liwh] #311


## v0.1.2 / 2011-11-20 (25)

### 功能(7):

1. 官网后台可以看到服务器状态[saberma] #280
2. 主题详情无示例时隐藏示例链接[saberma] #273
3. 官网后台管理要显示商店的链接地址[liwh] #270
4. 商店后台发送重置密码报错[liwh] #279
5. 商店顾客使用liquid方式实现[liwh] #258
6. 补充订单邮件测试[liwh] #257
7. 用户可以访问api[liwh] #185

### 缺陷(18):

1. 商店[关于我们]页面不应显示为页面不存在[saberma] #295
2. 后台管理查看商品详情提示'控件不可见'[saberma] #294
3. 后台管理查询結果第一条记录会被'应用'菜单覆盖[saberma] #293
4. 主题管理无法上传zip主题解压包[saberma] #290
5. 外观设置无法上传图片[saberma] #289
6. 主题商店点击获取主题没有反应[saberma] #288
7. 不同的商店允许使用相同的邮箱[saberma] #287
8. 结算页面没有显示样式[saberma] #285
9. 商店查询不应显示'此页面不存在'[saberma] #284
10. 外观设置没有显示配置项[saberma] #274
11. 官网后台管理找不到datepicker的图片[saberma] #277
12. ie的问题[saberma] #271
13. jquery.easing.1.3.js附件找不到[saberma] #272
14. 注册成功不应该跳转至商店[saberma] #268
15. 主题商店：提交url 问题[liwh] #275
16. 访问不存在的商店时，显示新建提示[liwh] #276
17. 访问不存在的商店时要显示404页面[liwh] #269
18. 邮件报错[liwh] #278


## v0.1.1 / 2011-10-09 (30)

### 功能(8):

1. 加入google统计[saberma] #254
2. 主题记录增加排序字段[saberma] #245
3. 链接列表模板变量要支持title，集合模板变量要支持迭代[saberma] #242
4. product变量要支持price_varies属性[saberma] #238
5. 商店附件url地址后要带文件修改时间[saberma] #230
6. 外观设置要支持class为linklist的下拉框显示链接列表[saberma] #235
7. 模板变量product增加市场价格属性[saberma] #229
8. 用户头像改为本地存储[liwh] #237

### 缺陷(22):

1. 结算页面显示¥undefined[saberma] #262
2. 登录后购物车会被清空[saberma] #260
3. shopqi测试商店没有安装默认主题[saberma] #227
4. shopqi测试商店安装主题时报认证失败[saberma] #228
5. 商店首页商品顺序在集合中手动排序不生效[saberma] #231
6. 后台管理ie7的问题[saberma] #232
7. 主题商店问题[saberma] #250
8. 商店顾客页面不能使用layout/admin[saberma] #249
9. ActiveRecord::StatementInvalid in Shop::CartController#update[saberma] #248
10. 登录shopqi后无法以myshopqi身份登录后台[saberma] #247
11. 官网后台更新主题压缩包文件没有即时生效[saberma] #233
12. 商店模板调用商品featured_image报错[saberma] #234
13. 链接列表修改后新增记录会出现重复记录[saberma] #243
14. 外观设置复选框保存不生效[saberma] #241
15. 订单提交后，商店购物车未清空[saberma] #240
16. 商品标签的样式不正确，标签换行了[saberma] #239
17. 结算流程中的商品图片未能显示[saberma] #244
18. 对图片进行压缩[liwh] #246
19. 主题应用，oauth2不能正确跳转[liwh] #251
20. 产品图片问题[liwh] #255
21. 文章需校验标题不能为空[liwh] #256
22. 主题导出有bug[liwh] #259

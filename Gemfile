#rails new . -d postgresql -T -J
source 'http://rubygems.org'

gem 'rails', '3.1.0'

##### 实体相关 #####
gem 'pg'
gem 'devise'

#use unicorn as web server
gem 'unicorn'

gem 'default_value_for'
gem 'thinking-sphinx', '2.0.5'
gem 'riddle', require: 'riddle/0.9.9' #sphinx无法获取CoreSeek版本
#gem 'riddle', git: 'git://github.com/saberma/riddle.git', branch: 'patch-1' #修改无法找到版本号的问题
gem 'ts-resque-delta', '1.0.0', require: 'thinking_sphinx/deltas/resque_delta'

gem 'active_hash' # 用于保存配置型(枚举)记录
gem 'kaminari' # 分页
#用于处理图片(缩略图)
gem 'dragonfly'
gem 'rack-cache', require: 'rack/cache'
gem 'liquid' #模板语言
gem "carrierwave"
#查询
#gem 'meta_where'
gem 'meta_search'
gem 'squeel'

#gem 'carmen'#地区
gem 'carmen', git: "git://github.com/jim/carmen.git"
gem 'seedbank' # 分离出各个环境下的seed
gem 'gravtastic' #gravtastic头像服务

##### 控制器相关 #####
gem 'decent_exposure'
gem 'sentient_user' # 将current_user设置至线程中
gem "mini_magick" # 调用参数说明:http://www.imagemagick.org/Usage/

##### 视图相关 #####
gem 'haml'
gem 'message_block' #用于显示错误信息
gem 'client_side_validations' #客户端校验

##### 其他 #####
gem "activemerchant" # 支付
gem "activemerchant_patch_for_china"
gem "httparty"
gem "resque" # 后台任务
gem "chinese_pinyin" # 汉字转拼音
gem "nokogiri" # 解释模板config/settings.html
gem "uuid" # 生成36位(或32位)唯一序列号
gem 'settingslogic' #用于解析一些配置信息
#gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'
gem 'grit', git: 'git://github.com/mojombo/grit.git' # 主题版本控制(每个商店主题都是一个git repository)
gem 'oauth2' # 提供访问oauth provider的客户端访问接口,服务端(Provider)使用http://j.mp/nCZiUj, 代码放在 lib/oauth2
#gem 'newrelic_rpm' # 性能监控(模板编辑器中的layout/theme.liquid也会被注入script,暂时不使用此gem)
gem "jquery-rails"
gem 'gollum', git: 'git://github.com/github/gollum.git'  #用于wiki系统
gem 'RedCloth'

group :development do
  gem 'rails3-generators'
  gem "haml-rails"
  gem 'guard'
  gem 'guard-livereload' # 修改后台文件后，safari或chrome浏览器会自动刷新
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby-debug19', platforms: :ruby_19 # To use debugger(add 'debugger' in code, then set autoeval; set autolist in console)
  gem 'rails-dev-boost', git: 'git://github.com/thedarkone/rails-dev-boost.git', require: 'rails_development_boost' # 加快开发时的响应速度
end

group :development, :test do
  gem "awesome_print", require: 'ap' # 调试
  gem "interactive_editor"
  # 编译coffee-script
  gem 'therubyracer', require: nil # 安装编译过程太慢(大概需要4分钟，导致travi-ci timeout)
  gem 'mustang' # 一修改coffee文件就报错误:lib/mustang/context.rb:18: [BUG] Segmentation fault
end

group :test, :travis do
  gem "rspec-rails"
  gem 'capybara' , ' ~> 1.1.0'
  gem 'resque_spec' # resque测试
  gem 'database_cleaner' # 保持数据库处理干净状态
  gem 'spork' # 为测试加速的drb server(spork spec &)
end

group :development, :test, :travis do
  gem "factory_girl"
  gem "factory_girl_rails"
end

# Gems used only for assets and not required
# in production environments by default.
# rake assets:precompile 部署到生产环境下执行
group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
end

#rails new . -d postgresql -T -J
source 'http://rubygems.org'

gem 'rails', '3.1.0.rc8'

##### 实体相关 #####
gem 'pg'
#gem 'devise'         , '~> 1.4.2' #由于更新版还未发布解决 bcrypt-ruby 兼容问题
gem 'devise', git: 'git://github.com/plataformatec/devise.git'

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
gem 'carmen'
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
gem 'grit' # 主题版本控制(每个商店主题都是一个git repository)
gem 'oauth2'
gem 'newrelic_rpm' # 性能监控

group :development do
  gem 'rails3-generators'
  gem "jquery-rails"
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
  gem 'execjs'
  gem 'barista'
end

group :test, :travis do
  gem "rspec-rails"
  gem 'capybara'
  gem 'resque_spec' # resque测试
  gem 'database_cleaner' # 保持数据库处理干净状态
  gem 'spork' # 为测试加速的drb server(spork spec &)
end

group :development, :test, :travis do
  gem "factory_girl"
  gem "factory_girl_rails"
end


#group :assets do
#  gem 'sass-rails', "  ~> 3.1.0.rc"
#  gem 'coffee-rails', "~> 3.1.0.rc"
#  gem 'uglifier'
#end


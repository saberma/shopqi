#rails new . -d postgresql -T -J
source 'http://rubygems.org'

gem 'rails', '3.2.7'

##### 实体相关 #####
gem 'pg'
gem 'devise', '~> 2.1.2'
gem 'sass-rails' # 放在assets分组会报错 http://j.mp/oj7y6K


gem 'activeadmin'
gem 'acts_as_list', git: 'git://github.com/saberma/acts_as_list.git' # 支持同时删除多个记录

#use unicorn as web server
gem 'unicorn'

gem 'default_value_for'
gem 'sunspot_rails',  '~> 1.3.3'

gem 'active_hash' # 用于保存配置型(枚举)记录
gem 'kaminari' # 分页
#用于处理图片(缩略图)
gem 'dragonfly', ' ~> 0.9.8'
gem 'rack-cache', require: 'rack/cache'
gem 'liquid','~> 2.3.0' #模板语言
gem "carrierwave", '~> 0.6.2'
gem 'meta_search', '~> 1.1.1' #查询
gem 'squeel'
gem 'seedbank' # 分离出各个环境下的seed

##### 控制器相关 #####
gem 'decent_exposure'
gem 'sentient_user' # 将current_user设置至线程中
gem "mini_magick" # 调用参数说明:http://www.imagemagick.org/Usage/

##### 视图相关 #####
gem 'haml', '~> 3.2.0.alpha.14'
gem 'message_block' #用于显示错误信息
gem 'client_side_validations' #客户端校验
gem 'therubyracer', require: nil unless ENV['TRAVIS'] # 编译coffee-script # 安装编译过程太慢(大概需要4分钟)

##### 其他 #####
gem "activemerchant" # 支付
gem "activemerchant_patch_for_china", git: "git://github.com/saberma/activemerchant_patch_for_china.git" # 支持多个支付帐户(待完成其他财付通等类型后再send pull request)
gem "httparty"
#gem "resque" # 后台任务
gem "resque", "~> 1.21.0"
gem "resque-scheduler", "~> 2.0.0"
gem "chinese_pinyin" # 汉字转拼音
gem "nokogiri" # 解释模板config/settings.html
gem "uuid" # 生成36位(或32位)唯一序列号
gem 'settingslogic' #用于解析一些配置信息
#gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'
gem 'grit', git: 'git://github.com/mojombo/grit.git' # 主题版本控制(每个商店主题都是一个git repository) # 2.4.1版本存在此问题 http://j.mp/uoEKw1
gem 'doorkeeper', '~> 0.4.0'
gem "oauth2", "~> 0.8.0"
gem 'rabl' # 构造 json api 数据
#gem 'newrelic_rpm' # 性能监控(模板编辑器中的layout/theme.liquid也会被注入script,暂时不使用此gem)
gem "jquery-rails"
gem 'rubyzip' # 解压缩用户上传的主题zip文件
gem 'gollum', git: 'git://github.com/saberma/gollum.git'  #用于wiki系统，1.3.1需要安装Pygments http://j.mp/uHMN1L，开发版本使用payments.rb，但有waring提示'did not have a valid gemspec'
gem 'RedCloth'
gem 'sitemap_generator' # 生成搜索引擎友好的sitemap # bundle exec rake sitemap:refresh:no_ping
gem 'exception_notification' # 发生异常时邮件通知

group :development do
  gem 'rails3-generators'
  gem "haml-rails"
  #gem 'ruby-debug19', platforms: :ruby_19 # To use debugger(add 'debugger' in code, then set autoeval; set autolist in console)
  gem 'rvm-capistrano', '~> 1.2.5'
  gem "letter_opener"
  gem 'guard-livereload'
end

group :development, :test do
  unless ENV['TRAVIS'] # 特殊处理，去掉在travis-ci中不需要的gem
    gem "awesome_print", require: 'ap' # 调试
    gem 'sunspot_solr',  '~> 1.3.3'
  end
  gem "factory_girl"
  gem "factory_girl_rails"
end

group :test do
  gem "selenium-webdriver", "~> 2.25.0"
  gem "rspec-rails"
  gem 'capybara' , ' ~> 1.1.2'
  gem 'resque_spec' # resque测试
  gem 'database_cleaner' # 保持数据库处理干净状态
  gem 'spork' # 为测试加速的drb server(spork spec &)
  gem 'webmock' # 模拟外部应用 HTTP 响应(fakeweb 不支持 post 数据)
  gem 'json_expressions' # 用于测试 API 返回的 JSON
  gem 'timecop' # 锁定当前时间
end

group :production do
  gem 'memcache-client'
end

# Gems used only for assets and not required
# in production environments by default.
# rake assets:precompile 部署到生产环境下执行
group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'susy', '~> 1.0.rc.1'
  gem 'sassy-buttons'
end

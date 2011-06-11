#rails new . -d postgresql -T -J
source 'http://rubygems.org'

gem 'rails', '3.0.6'

##### 实体相关 #####
gem 'pg'
gem 'devise'
gem 'default_value_for'


gem 'active_hash' # 用于保存配置型(枚举)记录
gem 'kaminari' # 分页
#用于处理图片(缩略图)
gem 'dragonfly'
gem 'rack-cache', require: 'rack/cache'
gem 'liquid' #模板语言
gem "carrierwave"
#查询
gem 'meta_where'
gem 'meta_search'

##### 控制器相关 #####
gem 'decent_exposure'
gem 'sentient_user' # 将current_user设置至线程中
gem "mini_magick" # 调用参数说明:http://www.imagemagick.org/Usage/

##### 视图相关 #####
gem 'haml'
# 编译coffee-script
gem 'therubyracer', require: nil
gem 'barista'
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

group :development, :test, :travis do
  gem "awesome_print", require: 'ap' # 调试
  gem 'rails-dev-boost', git: 'git://github.com/thedarkone/rails-dev-boost.git', require: 'rails_development_boost' # 加快开发时的响应速度
end

group :development do
  gem 'rails3-generators'
  gem "jquery-rails"
  gem "haml-rails"
  gem 'guard'
  gem 'guard-livereload' # 修改后台文件后，safari或chrome浏览器会自动刷新
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby-debug19', platforms: :ruby_19 # To use debugger(add 'debugger' in code, then set autoeval; set autolist in console)
end

group :test, :travis do
  gem "rspec-rails"
  gem "factory_girl"
  gem "factory_girl_rails"
  gem 'capybara', git: 'git://github.com/jnicklas/capybara.git' # 集成测试，最新版才支持:js=>true参数
  gem 'resque_spec' # resque测试
  gem 'database_cleaner' # 保持数据库处理干净状态
  gem 'spork' # 为测试加速的drb server(spork spec &)
end

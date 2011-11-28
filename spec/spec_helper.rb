require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  Capybara.default_wait_time = 5

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
    #automatically included devise testhelpers
    config.include Devise::TestHelpers, :type => :controller
    #If repeating "FactoryGirl" is too verbose for you, you can mix the syntax methods in
    config.include Factory::Syntax::Methods

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = true
  end

end

Spork.each_run do

  FactoryGirl.factories.clear
  Dir[Rails.root.join("spec/factories/**/*.rb")].each{|f| load f}
  Shopqi::Application.reload_routes!

  # This code will be run each time you run your specs.
  RSpec.configure do |config|
    config.include Factory::Syntax::Methods
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation #, {:except => %w[foo]} # 清除数据时排除某个表
      DatabaseCleaner.clean_with :truncation #, {:except => %w[foo]}
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session) # 取消与Sunspot的连接
    end

    config.before(:each, searchable: true) do #http://j.mp/quFhWM
      Sunspot.session = Sunspot.session.original_session
    end

    config.after(:each, searchable: true) do
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session) # 取消与Sunspot的连接
    end

    config.before(:each) do
      puts "travis?: #{travis?}"
      if travis? and Capybara.current_driver == :selenium # xvfb headless
        puts "Require headless."
        require 'headless'
        headless = Headless.new
        headless.start
      end
      FileUtils.mkdir_p(File.join(Rails.root, 'public', 's', 'files', Rails.env))
      # sentient_user
      Thread.current[:user] = nil
      DatabaseCleaner.start
      client = Factory(:oauth2_client) # 保存与db/seeds.rb一致，生成themes client
      Factory(:oauth2_consumer_client, client_id: client.client_id, client_secret: client.client_secret)
    end

    config.after(:each) do
      DatabaseCleaner.clean
      FileUtils.rm_rf(File.join(Rails.root, 'public', 's', 'files', Rails.env))
      FileUtils.rm_rf(File.join(Rails.root, 'data', 'shops', Rails.env))
      #CarrierWave.clean_cached_files!
      if travis? and Capybara.current_driver == :selenium # xvfb headless
        puts "Destroy headless."
        headless.destroy
      end
    end
  end
end


# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading
#   code that you don't normally modify during development in the
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.

# 上传文件
def raw_attach_file(file)
  request.env['RAW_POST_DATA'] = File.read(file) # 模拟ajax上传附件，上传后控制器通过request.raw_post获取文件内容 http://j.mp/n71jxS http://j.mp/ouLYdw
end

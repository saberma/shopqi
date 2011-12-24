# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

require 'resque/tasks'
require 'resque_scheduler/tasks'
task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection } # 第二次执行resque任务时失败 PGError: ERROR: prepared statement "a3" already exists 参考 http://j.mp/rpVqhc http://j.mp/rqj9CQ ;Rails已经打了补丁，未发布版本 http://j.mp/ntPQMr
end

namespace :travis do

  desc "Init database"
  task :init_db do # 并发时使用不同的数据库，否则偶尔会死锁(deadlock detected)
    unit_test = ENV['UNIT_TEST']
    integrate_test = ENV['INTEGRATE_TEST']
    path = Rails.root.join 'config/database.yml.example'
    configs = YAML.load_file(path)
    db_name = "#{configs[Rails.env]['database']}_#{unit_test && 'u_'}#{unit_test || integrate_test}"
    configs[Rails.env]['database'] = db_name
    File.open(path, 'w') {|f| YAML.dump(configs, f) }
  end

  desc "Run travis in parallel"
  task :parallel do
    parallel_size = 5
    unit_test = ENV['UNIT_TEST']
    integrate_test = ENV['INTEGRATE_TEST']
    all_files = Dir.chdir(Rails.root) { Dir["spec/**/*_spec.rb"]}.sort
    integrate_files = Dir.chdir(Rails.root) { Dir["spec/requests/**/*_spec.rb"]}.sort
    unit_files = all_files - integrate_files
    %w(shop/shops_searches_spec.rb lookup_spec.rb).each do |searchable_spec|
      integrate_files.delete "spec/requests/#{searchable_spec}" # 需要solr才能运行
    end
    files = if unit_test # 7个并发
            unit_files.in_groups(parallel_size)[unit_test.to_i-1].join(' ')
          elsif integrate_test # 7个并发
            integrate_files.in_groups(parallel_size)[integrate_test.to_i-1].join(' ')
          end

    cmd = "rspec #{files}"
    #cmd = "rspec spec/requests/shop/shop_orders_spec.rb spec/requests/shop/shop_customers_spec.rb" # selenium-webdriver 2.14未清空session，按此顺序运行，第二个用例失败
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end

end

Shopqi::Application.load_tasks

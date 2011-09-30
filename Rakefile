# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

require 'resque/tasks'
require 'resque_scheduler/tasks'
task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection } # 第二次执行resque任务时失败 PGError: ERROR: prepared statement "a3" already exists 参考 http://j.mp/rpVqhc http://j.mp/rqj9CQ ;Rails已经打了补丁，未发布版本 http://j.mp/ntPQMr
end

Shopqi::Application.load_tasks

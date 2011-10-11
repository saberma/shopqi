#export CAP_RVM_RUBY=ruby-1.9.2
#export CAP_PORT=10000
#export CAP_WEB_HOST=188.188.188.188
#export CAP_APP_HOST=$CAP_WEB_HOST
#export CAP_DB_HOST=$CAP_WEB_HOST
#export CAP_USER=deploy
require "bundler/capistrano" # 集成bundler和rvm
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))   # Add RVM's lib directory to the load path.
require "rvm/capistrano"                                 # Load RVM's capistrano plugin.
set :rvm_ruby_string, ENV['CAP_RVM_RUBY']                # Or whatever env you want it to run in.
set :rvm_type, :user                                     # Copy the exact line. I really mean :user here

set :application, "shopqi"
set :port, ENV['CAP_PORT']
role :web, ENV['CAP_WEB_HOST']                          # Your HTTP server, Apache/etc
role :app, ENV['CAP_APP_HOST']                          # This may be the same as your `Web` server
role :db,  ENV['CAP_DB_HOST'], primary: true            # This is where Rails migrations will run
#role :db,  "your slave db-server here"


set :repository,  "git://github.com/saberma/shopqi.git"
set :scm, :git
#set :deploy_to, "/u/apps/shopqi" # default
set :deploy_via, :remote_cache # 不要每次都获取全新的repository
set :branch, "master"
set :user, ENV['CAP_USER']
set :use_sudo, false

depend :remote, :gem, "bundler", ">=1.0.21" # 可以通过 cap deploy:check 检查依赖情况

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  #task :start do ; end
  #task :stop do ; end
  #task :restart, :roles => :app, :except => { :no_release => true } do
  #  run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  #end

  # scp -P 10000 config/{database,sms,alipay,admin_users}.yml deploy@188.188.188.188:/u/apps/shopqi/shared/config/
  desc "Symlink shared resources on each release"
  task :symlink_shared, roles: :app do
    %w(database sms alipay admin_users).each do |secure_file|
      run "ln -nfs #{shared_path}/config/#{secure_file}.yml #{release_path}/config/#{secure_file}.yml"
    end
  end

end
after 'deploy:update_code', 'deploy:symlink_shared'

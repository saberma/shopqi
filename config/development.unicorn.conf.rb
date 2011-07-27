# unicorn_rails -p 4000 -c config/development.unicorn.conf.rb
worker_processes 3 # 测试主题商店切换主题时至少需要两个进程
timeout 600

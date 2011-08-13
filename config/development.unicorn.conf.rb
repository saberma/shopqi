# unicorn_rails -p 4000 -c config/development.unicorn.conf.rb
worker_processes 2 # 测试主题商店切换主题时至少需要两个进程
timeout 600
#preload_app true # newrelic http://j.mp/njs0KG # 此命令在开发环境下有时抛出异常 attributes没有定义

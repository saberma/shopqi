# encoding: utf-8

unless OAuth2::Model::Client.exists?(name: 'themes')
  client = OAuth2::Model::Client.create name: 'themes', redirect_uri: Theme.redirect_uri # 注册主题Client，用于商店切换主题操作
  puts 'please copy the key and secret to config/clients.yml'
  puts "client_id: #{client.client_id}"
  puts "client_secret: #{client.client_secret}"
end

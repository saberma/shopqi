# encoding: utf-8
############### 注意 ###############
#
#  数据操作都放这里，不要放在migrate脚本
#  放在这里的数据都要支持多次执行
#  例如:新增操作执行前要判断未存在
#
############### 注意 ###############

# 创建官网管理员
admin_users =  YAML::load_file(Rails.root.join('config/admin_users.yml'))
admin_users.each_value do |attr|
  AdminUser.create!(attr) unless AdminUser.exists?(email: attr['email'])
end

unless OAuth2::Model::Client.exists?(name: 'themes')
  redirect_uri = "http://themes.#{Setting.host}#{':4000' if development?}/callback"
  client = OAuth2::Model::Client.create name: 'themes', redirect_uri: redirect_uri # 注册主题Client，用于商店切换主题操作
  #OAuth2::Model::ConsumerClient.create name: 'themes', client_id: client.client_id, client_secret: client.client_secret
end

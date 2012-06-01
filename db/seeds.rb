# encoding: utf-8
############### 注意 ###############
#
#  数据操作都放这里，不要放在migrate脚本
#  放在这里的数据都要支持多次执行
#  例如:新增操作执行前要判断未存在
#
############### 注意 ###############

# 创建官网管理员
SecretSetting.admin_users.each_value do |attr|
  AdminUser.create!(attr) unless AdminUser.exists?(email: attr['email'])
end

unless Doorkeeper::Application.exists?(name: Theme.client_name)
  Doorkeeper::Application.create! name: Theme.client_name, redirect_uri: Theme.redirect_uri # 注册主题Client，用于商店切换主题操作
end

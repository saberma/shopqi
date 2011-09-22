# encoding: utf-8
class ThemeMailer < ActionMailer::Base
  default :from => "shopqi_test@163.com"

  def export(shop, name, tar_gz_content)
    user = shop.users.where(admin: true).first
    attachments[name] = tar_gz_content #File.read(path)
    mail to: "#{user.name} <#{user.email}>", subject: "您在ShopQi导出的主题文件"
  end

end

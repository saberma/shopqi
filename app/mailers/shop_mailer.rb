class ShopMailer < ActionMailer::Base
  default :from => "weihuilee@163.com"

  def welcome
    mail(to: '346856439@qq.com',body:"aaa", subject: "welcome")
  end
end

class ShopMailer < ActionMailer::Base
  default :from => "shopqi_test@163.com"

  def welcome
    mail(to: '346856439@qq.com',body:"aaa", subject: "welcome")
  end
end

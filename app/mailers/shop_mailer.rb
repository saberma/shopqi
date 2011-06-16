class ShopMailer < ActionMailer::Base
  default :from => "shopqi_test@163.com"

  def notify_email(object,liquid_drop,email_template)
    liquid_hash = liquid_drop.to_liquid
    mail(to: object.email,body:Liquid::Template.parse(email_template.body).render(liquid_hash), subject: Liquid::Template.parse(email_template.title).render(liquid_hash))
  end

end

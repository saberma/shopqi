class ShopMailer < ActionMailer::Base
  default :from => "shopqi_test@163.com"

  def notify_email(email,liquid_drop,email_template)
    liquid_hash = liquid_drop.as_json
    body        = email_template.include_html ? email_template.body_html : email_template.body #判断用text/plain模版还是html模版
    type        = email_template.include_html ? 'text/html' : 'text/plain'
    mail(to: email,body: Liquid::Template.parse(body).render(liquid_hash), subject: Liquid::Template.parse(email_template.title).render(liquid_hash),content_type: type)
  end

end

class AddOrderPaidEmailNotify < ActiveRecord::Migration
  def up
    KeyValues::Mail::Type.find([26,27]).each do |type| # 加上订单支付邮件提醒
      Shop.all.each do |shop|
        title, body = type.title_body
        shop.emails.create title: title, mail_type: type.code, body: body
      end
    end
  end

  def down
    Email.where(mail_type: KeyValues::Mail::Type.find([26,27]).map(&:code)).delete_all
  end
end

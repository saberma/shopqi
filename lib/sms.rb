#encoding: utf-8
class SMS # 短信接口

  # 发送短信，限制每个phone一天内最多发10次
  # 每个ip60秒最多发1次，注意部署时proxy的设置，以使remote_ip生效
  def self.safe_send(receiver, content, remote_ip)
    ip_key = "sending_from:#{remote_ip}"
    phone_key = "sending_to:#{receiver}"
    Rails.cache.fetch ip_key, expires_in: 1.minute do
      send_times = Rails.cache.fetch(phone_key, expires_in: 24.hours){ 10 }
      if send_times > 0
        Rails.cache.decrement phone_key
        self.send receiver, content
      end
    end
  end

  def self.send(receiver, content) # 发送短信
    content += " 【ShopQi电子商务平台】" # 短信平台要求签名结尾
    config = YAML::load_file(Rails.root.join('config/sms.yml'))
    url = "http://#{config['smsapi']}/#{config['charset']}/interface/send_sms.aspx"
    res = Net::HTTP.post_form(URI.parse(url), username: config['username'], password: config['password'], receiver: receiver, content: content)
    res.body
  end

end

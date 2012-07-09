# encoding: utf-8
module WebhookWorker

  @queue = "webhook_worker"

  def self.perform(callback_url, options, time = 0)
    response = HTTParty.post(callback_url, options)
    if response.code != 200 # 发生错误
      if time > 0 and time < EXPONENTIAL_BACKOFF.size
        Resque.enqueue_in(EXPONENTIAL_BACKOFF[time].seconds, WebhookWorker, callback_url, options, time + 1)
      else
        # TODO: 发邮件通知商店管理员或应用网站管理员
      end
    end
  end

end

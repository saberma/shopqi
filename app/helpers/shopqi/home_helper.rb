module Shopqi::HomeHelper

  def is_registered? # 是否已经注册过商店
    Rails.cache.read(registered_cache_key)
  end

  def registered_cache_key
    "registered_#{request.remote_ip}"
  end

end

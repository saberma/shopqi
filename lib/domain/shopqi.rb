# encoding: utf-8
module Domain

  #官网
  class Shopqi
    def self.matches?(request)
      request.host.end_with?(Setting.host) # 域名以shopqi.com结尾
    end
  end

end

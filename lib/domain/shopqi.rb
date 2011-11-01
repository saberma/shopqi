# encoding: utf-8
module Domain

  #官网
  class Shopqi
    def self.matches?(request)
      host = request.host
      subdomain = request.subdomain
      host.end_with?(Setting.host) and (subdomain.blank? or %w(www).include?(subdomain)) # 域名以shopqi.com结尾
    end
  end

end

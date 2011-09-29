# encoding: utf-8
module Domain

  #官网
  class Shopqi
    def self.matches?(request)
      subdomain = request.subdomain
      !subdomain.present?
    end
  end

end

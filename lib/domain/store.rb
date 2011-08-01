# encoding: utf-8
module Domain

  class Store
    def self.matches?(request)
      excludes = %w(www checkout)
      subdomain = request.subdomain
      host = request.host
      subdomain.present? && !excludes.include?(subdomain) && ShopDomain.exists?(host: host)
    end
  end

end

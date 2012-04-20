# encoding: utf-8
module Domain

  class Store
    def self.matches?(request)
      host = request.host
      ShopDomain.valid_exists?(host)
    end
  end

  class NoStore
    def self.matches?(request)
      host = request.host
      !ShopDomain.valid_exists?(host) && !request.subdomain.blank?
    end
  end

end

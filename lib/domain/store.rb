# encoding: utf-8
module Domain

  class Store
    def self.matches?(request)
      host = request.host
      ShopDomain.exists?(host: host)
    end
  end

  class NoStore
    def self.matches?(request)
      host = request.host
      !ShopDomain.exists?(host: host)
    end
  end

end

# encoding: utf-8
module Domain

  class Checkout
    def self.matches?(request)
      subdomain = request.subdomain
      subdomain.present? && subdomain == 'checkout'
    end
  end

end

# encoding: utf-8
module Domain

  class Checkout
    def self.matches?(request)
      request.host == "checkout.#{Setting.host}" #checkout.shopqi.com
    end
  end

end

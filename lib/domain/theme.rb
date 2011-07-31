# encoding: utf-8
module Domain

  class Theme
    def self.matches?(request)
      subdomain = request.subdomain
      subdomain.present? && subdomain == 'themes'
    end
  end

end

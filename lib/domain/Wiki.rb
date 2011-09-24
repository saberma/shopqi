module Domain
  class Wiki
    def self.matches?(request)
      subdomain = request.subdomain
      subdomain.present? && subdomain == 'wiki'
    end
  end
end

module Domain
  class Wiki
    def self.matches?(request)
      request.host == "wiki.#{Setting.host}" #wiki.shopqi.com
    end
  end
end

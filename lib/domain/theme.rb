# encoding: utf-8
module Domain

  class Theme
    def self.matches?(request)
      request.host == "themes.#{Setting.host}" #themes.shopqi.com
    end
  end

end

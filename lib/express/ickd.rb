# encoding: utf-8
module Express # 快递查询

  class Ickd
    include HTTParty
    base_uri 'http://api.ickd.cn'
    format :json
    default_params type: :json, encode: :utf8, ord: :asc, id: SecretSetting.express.ickd.key
    #debug_output

    # @com 快递公司拼音
    # @nu 运单号
    def self.search(com, nu)
      options= { com: com, nu: nu }
      get("/", query: options)
    end

  end

end


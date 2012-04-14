# encoding: utf-8
module Gateway # 支付网关

  class Alipay
    include HTTParty
    base_uri 'https://mapi.alipay.com'

    def self.send_goods?(options, account, key, email) # 直接返回操作成功結果
      send_goods(options, account, key, email)['alipay']['is_success'] == 'T'
    end

    # @options = {
    #   'logistics_name' => '申通E物流', # 物流公司名称
    #   'invoice_no' => 'abcd1234', # 发货单号
    #   'trade_no' => '1234567890' # 支付宝交易号
    # }
    def self.send_goods(options, account, key, email)
      options.merge!({
        'service' => 'send_goods_confirm_by_platform', # 后台发送发货信息，而非由用户集成支付宝的操作页面
        'transport_type' => 'EXPRESS', # 物流类型
        'seller_email' => email, 'partner' => account, '_input_charset' => 'utf-8'
      })
      options.merge!('sign_type' => 'MD5', 'sign' => Digest::MD5.hexdigest(options.sort.map{|k,v|"#{k}=#{v}"}.join("&")+key))
      get("/gateway.do", query: options)
    end

  end

end


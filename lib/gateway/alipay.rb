# encoding: utf-8
module Gateway # 支付网关

  module Alipay
    GATEWAY_URI = 'https://mapi.alipay.com'
    GATEWAY_PATH = "/gateway.do"

    module Verifier
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def verify_sign?(params, key) # 校验 md5
          sign_type = params.delete("sign_type")
          sign = params.delete("sign")

          md5 = params.sort.collect do |k, v|
            v = CGI.unescape(v) if k == 'notify_id'
            "#{k}=#{v}"
          end
          Digest::MD5.hexdigest(md5.join("&") + key) == sign.downcase
        end

        # @notify_id 从支付宝服务器传递过来的校验 ID 值
        # @account 即为 partner，合作者身份，以 2088 开头的 16 位数字
        def verify_source?(notify_id, account)
          result = HTTParty.get("#{Alipay::GATEWAY_URI}#{Alipay::GATEWAY_PATH}", query: {service: 'notify_verify', partner: account, notify_id: notify_id}).body
          result == 'true'
        end

        def sign!(options, key) # MD5 签名
          options.merge!('sign_type' => 'MD5', 'sign' => Digest::MD5.hexdigest(options.sort.map{|k,v|"#{k}=#{v}"}.join("&") + key))
        end
      end

    end

    module Goods # 同步发货信息接口
      include HTTParty
      include Gateway::Alipay::Verifier
      base_uri GATEWAY_URI

      def self.send?(options, account, key, email) # 直接返回操作成功結果
        send(options, account, key, email)['alipay']['is_success'] == 'T'
      end

      # @options = {
      #   'logistics_name' => '申通E物流', # 物流公司名称
      #   'invoice_no' => 'abcd1234',      # 发货单号
      #   'trade_no' => '1234567890'       # 支付宝交易号
      # }
      # @account 即为 partner，合作者身份，以 2088 开头的 16 位数字
      # @email 卖家帐号(Email地址或者手机号)
      def self.send(options, account, key, email)
        options.merge!({
          'seller_email' => email, 'partner' => account, '_input_charset' => 'utf-8',
          'service' => 'send_goods_confirm_by_platform', # 后台发送发货信息，而非由用户集成支付宝的操作页面
          'transport_type' => 'EXPRESS'                  # 物流类型
        })
        sign! options, key
        get Alipay::GATEWAY_PATH, query: options
      end

    end

    module Refund # 支付宝即时到帐批量退款有密接口(此为异步接口，有密指通过此接口打开 url 后需要用户输入支付宝的支付密码进行退款)
      include Gateway::Alipay::Verifier

      # 返回批量申请退款的 url 地址串
      # @account 即为 partner，合作者身份，以 2088 开头的 16 位数字
      # @email 卖家帐号(Email地址或者手机号)
      # @options = {
      #   'batch_no' => '201210181153598348493276', # 退款批次号(退款日期(8 位) + 流水号(3~24 位)，不可重复，用于回查此退款详情
      #   'data' => [
      #     {
      #       'trade_no' => '1234567890', # 支付宝交易号、退款金额
      #       'amount' => 45,             # 退款金额
      #       'reason' => '协商退款'      # 退款理由(不能有 ^|$# 字符)
      #     }
      #   ]
      #   'notify_url' => 'http://',      # 返回申请結果的通知地址(可空)
      # }
      def self.apply_url(account, key, email, options)
        data = options.delete('data')
        detail_data = data.map{|item| "#{item['trade_no']}^#{item['amount']}^#{item['reason']}"}.join('#')
        options.merge!({
          'seller_email' => email, 'partner' => account, '_input_charset' => 'utf-8',
          'service' => 'refund_fastpay_by_platform_pwd',  # 接口名称
          'refund_date' => Time.now.to_s(:db),            # 申请退款时间
          'batch_num' => data.size,                       # 总笔数
          'detail_data' => detail_data                    # 转换后的单笔数据集字符串
        })
        sign! options, key
        "#{GATEWAY_URI}#{GATEWAY_PATH}?#{options.to_query}"
      end

      # 退款批次号，支付宝通过此批次号来防止重复退款操作，所以此号生成后最好直接保存至数据库，不要在显示页面的时候生成
      # 共 24 位(8 位当前日期 + 9 位纳秒 + 1 位随机数)
      def self.generate_batch_no
        time = Time.now
        time.to_s(:number) + time.nsec.to_s + Random.new.rand(1..9).to_s
      end

      class Notification
        include Gateway::Alipay::Verifier
        attr_accessor :params

        ['batch_no', 'notify_id'].each do |param|
          self.class_eval <<-EOF
            def #{param}
              params['#{param}']
            end
          EOF
        end

        def initialize(post, key, account)
          @params = {}
          for line in post.split('&')
            k, v = *line.scan( %r{^(\w+)\=(.*)$} ).flatten
            params[k] = CGI.unescape(v || '')
          end
          raise StandardError.new("Alipay error: ILLEGAL_SIGN") unless self.class.verify_sign?(params, key)
          raise StandardError.new("Alipay error: ILLEGAL_NOTIFY_ID") unless self.class.verify_source?(notify_id, account)
        end

        def failure? # 失败
          params['success_ num'] == '0' # 成功笔数
        end

        # 交易号^退款金额^处理结果$退费账号^退费账户 ID^退费金额^处理结果
        # 2010031906272929^80^SUCCESS$jax_chuanhang@alipay.com^2088101003147483^0.01^SUCCESS
        # @return [["2010031906272929", "80", "SUCCESS", "jax_chuanhang@alipay.com", "2088101003147483", "0.01", "SUCCESS"]]
        def data
          params['result_details'].split('#').map{|item| Item.new item}
        end

        class Item
          attr_accessor :trade_no, :amount, :result

          def initialize(item_str)
            @trade_no, @amount, @result = item_str.split(/\^|\$/)
          end

          def success?
            result.upcase == 'SUCCESS'
          end
        end

      end

    end

  end

end

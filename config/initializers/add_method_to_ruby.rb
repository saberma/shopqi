#encoding: utf-8
EXPONENTIAL_BACKOFF = [1, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]

module LiquidDropHelper

  #由于liquid的hash只能是'key' => value形式
  #所以,key写成string的形式
  def as_json(options={})
    result = {}
    keys = self.public_methods(false)
    keys = keys - [:as_json, :options]
    keys.inject(result) do |result, method|
      result[method.to_s] = self.send(method)
      result
    end
    result
  end

end

Liquid::Drop.send :include , LiquidDropHelper

# 修正:DEPRECATION WARNING: Setting :expires_in on read has been deprecated in favor of setting it on write
def smart_fetch(name, options = {}, &blk)
  in_cache = Rails.cache.fetch(name)
  return in_cache if in_cache
  if block_given?
    val = yield
    Rails.cache.write(name, val, options)
    return val
  end
end

# cdn 域名地址
def asset_host
  host = ActionController::Base.asset_host # 可能为Proc对象
  host.respond_to?(:call) ? host.call : host
end

# 签名
def sign_hmac(secret, data)
  digest  = OpenSSL::Digest::Digest.new('sha256')
  Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
end

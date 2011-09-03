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

Carmen.default_locale = :cn


#增加subdomain属性
#rails 3.1默认支持subdomain和domain
#module UrlHelper
#  extend ActionDispatch::Routing::UrlFor
#
#  def with_subdomain(subdomain)
#    subdomain = (subdomain || "")
#    subdomain += "." unless subdomain.empty?
#    [subdomain, request.domain, request.port_string].join
#  end
#
#  def url_for(options = nil)
#    if options.kind_of?(Hash) && options.has_key?(:subdomain)
#      options[:host] = with_subdomain(options.delete(:subdomain))
#    end
#    super
#  end
#
#end

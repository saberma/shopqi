#encoding: utf-8
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

module Handle

  # @collection shop.products
  def self.make_valid(collection, model) # 确保handle唯一，替换空格为横杠(-)
    model.handle = Pinyin.t(model.title) if model.handle.blank?
    unique_handle = model.handle.strip.gsub /\s+/, '-'
    number = 1
    condition = {}
    condition[:id.not_eq] = model.id unless model.new_record?
    while collection.exists?(condition.merge(handle: unique_handle))
      unique_handle = "#{unique_handle}-#{number}"
      number += 1
    end
    model.handle = unique_handle
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

#用于邮件校验
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
      object.errors[attribute] << (options[:message] || "格式不对")
    end
  end
end

#用于验证sku数量超过商店限制后不能再新增商品和款式 issues#282
class SkuValidator < ActiveModel::Validator
  def validate(record)
    shop = record.shop || record.product.try(:shop)
    if !shop.nil? && shop.plan_type.skus <= shop.variants.size
      record.errors[:base] << "超过商店限制"
    end
  end
end

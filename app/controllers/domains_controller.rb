#encoding: utf-8
class DomainsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:shop_domains) { shop.domains }
  expose(:shop_domain)
  expose(:shop_domain_json) { shop_domain.to_json(except: [:created_at, :updated_at]) }
  expose(:shop_domains_json) { shop_domains.to_json(except: [:created_at, :updated_at]) }

  def check_dns
    text = :failed
    if shop_domain.is_myshopqi? # 子域名无须检测有效性
      text = :ok
    else
      begin
        cname = Resolv::DNS.new.getresource shop_domain.host, Resolv::DNS::Resource::IN::CNAME # 确保顶级域名存在cname，并且指向example.myshopqi.com
        text = :ok if !cname.nil? and cname.name.to_s == shop.domains.myshopqi.host
      rescue; end
    end
    render text: text
  end

  def create
    shop_domain.save
    render json: shop_domain.to_json
  end
end

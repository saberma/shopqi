#encoding: utf-8
class DomainsController < ApplicationController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop) { current_user.shop }
  expose(:domains) { shop.domains }
  expose(:domain)
  expose(:domains_json) { domains.to_json(except: [:created_at, :updated_at]) }

  def check_dns
    text = :failed
    if domain.is_myshopqi? # 子域名无须检测有效性
      text = :ok
    else
      begin
        cname = Resolv::DNS.new.getresource domain.host, Resolv::DNS::Resource::IN::CNAME # 确保顶级域名存在cname，并且指向example.myshopqi.com
        text = :ok if !cname.nil? and cname.name.to_s == shop.domains.myshopqi.host
      rescue; end
    end
    render text: text
  end
end

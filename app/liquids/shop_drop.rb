#encoding: utf-8
class ShopDrop < Liquid::Drop

  def initialize(shop, theme = nil, host = nil)
    @shop = shop
    @theme = theme || shop.theme
    @host = host
  end

  delegate :id, :name, :money_with_currency_format, :money_format, :money_with_currency_in_emails_format, :money_in_emails_format, to: :@shop
  delegate :id, :name, to: :@theme, prefix: :theme # 主题预览脚本使用

  def url
    @shop.primary_domain.url
  end

  def asset_url(asset) # UrlFilter调用
    @theme.asset_url(asset)
  end

  def customer_accounts_enabled # 启用顾客功能
    !@shop.customer_accounts.blank?
  end

  def types
    @types ||= @shop.types.map(&:name)
  end

  def vendors
    @vendors ||= @shop.vendors.map(&:name)
  end

  def domain_record # 备案号
    @shop.domains.where(host: @host).first.record
  end

end

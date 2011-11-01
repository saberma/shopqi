#encoding: utf-8
class ShopDrop < Liquid::Drop

  def initialize(shop, theme = nil)
    @shop = shop
    @theme = theme || shop.theme
  end

  delegate :id, :name, :money_with_currency_format, :money_format, :money_with_currency_in_emails_format, :money_in_emails_format, to: :@shop

  def url
    @shop.primary_domain.url
  end

  def asset_url(asset) # UrlFilter调用
    @theme.asset_url(asset)
  end

end
